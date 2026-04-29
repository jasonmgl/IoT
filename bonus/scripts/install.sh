#!/bin/bash

DEBIAN_FRONTEND=noninteractive

set -euo pipefail

if [[ -t 1 ]]; then
    RED=$'\e[31m'
    GREEN=$'\e[32m'
    ENDCOLOR=$'\e[0m'
else
    RED=''
    GREEN=''
    ENDCOLOR=''
fi

if [ ! -f ".env" ]; then
    printf '%s\n' "${RED}No .env found for this project${ENDCOLOR}"
    exit 1
else
    source .env >/dev/null 2>&1
fi

printf '%s\n' "${GREEN}.__                 __         .__  .__              .__     ${ENDCOLOR}"
printf '%s\n' "${GREEN}|__| ____   _______/  |______  |  | |  |        _____|  |__  ${ENDCOLOR}"
printf '%s\n' "${GREEN}|  |/    \ /  ___/\   __\__  \ |  | |  |       /  ___/  |  \ ${ENDCOLOR}"
printf '%s\n' "${GREEN}|  |   |  \___  \  |  |  / __ \|  |_|  |__     \___ \|   Y  \ ${ENDCOLOR}"
printf '%s\n' "${GREEN}|__|___|  /____  > |__| |____  /____/____/ /\ /____  >___|  /${ENDCOLOR}"
printf '%s\n' "${GREEN}        \/     \/            \/            \/      \/     \/ ${ENDCOLOR}"

sudo apt-get update -qq
sudo apt-get install -yqq ca-certificates curl >/dev/null
sudo install -m 0755 -d /etc/apt/keyrings

if ! grep -q "$ARGOCD_HOSTNAME" /etc/hosts; then
    echo "127.0.0.1 $ARGOCD_HOSTNAME $GITLAB_HOSTNAME $MINIO_HOSTNAME jmougel.local" | sudo tee -a /etc/hosts
fi

if ! command -v docker >/dev/null 2>&1; then
    sudo sh scripts/get-docker.sh
fi
printf '%s\n' "${GREEN}Docker Version: $(docker version --format '{{.Server.Version}}')${ENDCOLOR}"

if ! command -v kubectl >/dev/null 2>&1; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl && sudo mv kubectl /usr/local/bin/
fi
printf '%s\n' "${GREEN}$(kubectl version --client)${ENDCOLOR}"

if ! command -v k3d >/dev/null 2>&1; then
    sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.8.3 bash
    if ! sudo k3d cluster list bonus >/dev/null 2>&1; then
        sudo k3d cluster create --config confs/k3d-config.yaml
    fi
fi

printf '%s\n' "${GREEN}$(k3d version)${ENDCOLOR}"

if ! command -v helm >/dev/null 2>&1; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    sudo helm repo add gitlab http://charts.gitlab.io/ >/dev/null 2>&1 || true
    sudo helm repo add argo https://argoproj.github.io/argo-helm >/dev/null 2>&1 || true
fi
sudo helm repo update
printf '%s\n' "${GREEN}Helm: $(helm version --short)${ENDCOLOR}"

if ! command -v glab >/dev/null 2>&1; then
    curl -sL "https://gitlab.com/gitlab-org/cli/-/releases/v1.93.0/downloads/glab_1.93.0_linux_amd64.tar.gz" | sudo tar xz -C /usr/local bin/glab
fi
printf '%s\n' "${GREEN}$(glab --version)${ENDCOLOR}"

sudo kubectl apply -f confs/gitlab/namespace.yaml
sudo kubectl -n gitlab create secret generic gitlab-gitlab-initial-root-password --from-literal=password="$GITLAB_PASSWORD" --dry-run=client -o yaml | sudo kubectl apply -f -
sudo kubectl -n gitlab create secret generic gitlab-minio-secret --from-literal=accesskey="$MINIO_ACCESSKEY" --from-literal=secretkey="$MINIO_SECRETKEY" --dry-run=client -o yaml | sudo kubectl apply -f -
sudo helm upgrade --install gitlab gitlab/gitlab --version 9.10.3 --namespace gitlab --wait -f confs/gitlab/values.yaml --timeout 20m

if ! curl -sf -o /dev/null -H "PRIVATE-TOKEN: $GITLAB_TOKEN" "http://gitlab.local:8888/api/v4/projects/root%2Fjmougel_IoT_app"; then
    TOOLBOX=$(sudo kubectl -n gitlab get pod -l app=toolbox -o jsonpath='{.items[0].metadata.name}')
    sudo kubectl -n gitlab exec "$TOOLBOX" -- gitlab-rails runner "
        user = User.find_by(username: 'root')
        token = user.personal_access_tokens.find_or_initialize_by(name: 'cli')
        if token.new_record?
            token.scopes = ['api', 'write_repository']
            token.expires_at = 30.days.from_now
            token.set_token('$GITLAB_TOKEN')
            token.save!
        end
    "
    sleep 2
    glab auth login \
        --hostname gitlab.local:8888 \
        --token "$GITLAB_TOKEN" \
        --api-protocol http \
        --git-protocol http
    [ -d jmougel_IoT_app ] || git clone https://github.com/jasonmgl/jmougel_IoT_app.git
    git -C jmougel_IoT_app remote set-url origin "http://root:$GITLAB_TOKEN@gitlab.local:8888/root/jmougel_IoT_app.git"
    git -C jmougel_IoT_app push origin --all
    sudo rm -rf jmougel_IoT_app
fi

sudo kubectl apply -f confs/argocd/namespace.yaml
sudo helm upgrade --install argocd argo/argo-cd --version 9.5.2 --namespace argocd --wait -f confs/argocd/values.yaml --timeout 10m
sudo kubectl apply -f confs/argocd/argocd-app.yaml

sudo kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: argocd-app-repository
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: "$GITLAB_INTERNAL_REPOSITORY_URL"
  username: "$GITLAB_LOGIN"
  password: "$GITLAB_TOKEN"
EOF

if ! command -v argocd >/dev/null 2>&1; then
    ARGOCD_SECRET=$(sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d)

    sudo curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/download/v3.3.6/argocd-linux-amd64
    sudo chmod +x argocd
    sudo mv argocd /usr/local/bin/
    sudo argocd login $ARGOCD_HOSTNAME:8843 \
        --username $ARGOCD_LOGIN \
        --password $ARGOCD_SECRET \
        --insecure
    sudo argocd account update-password \
        --current-password $ARGOCD_SECRET \
        --new-password $ARGOCD_PASSWORD
    sudo kubectl delete secret argocd-initial-admin-secret -n argocd
fi
printf '%s\n' "${GREEN}$(argocd version --client)${ENDCOLOR}"

printf '%s\n' "-------------------------------------------------"
printf '%s\n' "Argo CD's credential"
printf '\n'
printf '%s\n' "login: $ARGOCD_LOGIN"
printf '%s\n' "password: $ARGOCD_PASSWORD"
printf '\n'
printf '%s\n' "address: http://$ARGOCD_HOSTNAME:8888/"
printf '%s\n' "-------------------------------------------------"
printf '%s\n' "-------------------------------------------------"
printf '%s\n' "Gitlab's credential"
printf '\n'
printf '%s\n' "login: $GITLAB_LOGIN"
printf '%s\n' "password: $GITLAB_PASSWORD"
printf '\n'
printf '%s\n' "address: http://$GITLAB_HOSTNAME:8888/"
printf '%s\n' "-------------------------------------------------"
printf '%s\n' "Minio's credential"
printf '\n'
printf '%s\n' "login: $MINIO_ACCESSKEY"
printf '%s\n' "password: $MINIO_SECRETKEY"
printf '\n'
printf '%s\n' "address: http://$MINIO_HOSTNAME:8888/"
printf '%s\n' "-------------------------------------------------"
