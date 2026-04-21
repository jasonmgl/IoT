#! /usr/bin/env bash

if [[ -t 1 ]]; then
    RED=$'\e[31m'
    GREEN=$'\e[32m'
    ENDCOLOR=$'\e[0m'
else
    RED=''
    GREEN=''
    ENDCOLOR=''
fi

set -euo pipefail

printf '%s\n' "${GREEN}.__                 __         .__  .__              .__     ${ENDCOLOR}"
printf '%s\n' "${GREEN}|__| ____   _______/  |______  |  | |  |        _____|  |__  ${ENDCOLOR}"
printf '%s\n' "${GREEN}|  |/    \ /  ___/\   __\__  \ |  | |  |       /  ___/  |  \ ${ENDCOLOR}"
printf '%s\n' "${GREEN}|  |   |  \___  \  |  |  / __ \|  |_|  |__     \___ \|   Y  \ ${ENDCOLOR}"
printf '%s\n' "${GREEN}|__|___|  /____  > |__| |____  /____/____/ /\ /____  >___|  /${ENDCOLOR}"
printf '%s\n' "${GREEN}        \/     \/            \/            \/      \/     \/ ${ENDCOLOR}"

sudo apt-get update -qq
sudo apt-get install -yqq ca-certificates curl >/dev/null
sudo install -m 0755 -d /etc/apt/keyrings

if ! command -v docker >/dev/null 2>&1; then
    sudo sh scripts/get-docker.sh
fi
printf '%s\n' "${GREEN}Docker Version : $(docker version --format '{{.Server.Version}}')${ENDCOLOR}"

if ! command -v kubectl >/dev/null 2>&1; then
    sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo chmod +x kubectl && mv kubectl /usr/local/bin/
fi
printf '%s\n' "${GREEN}Kubectl : $(kubectl version --client --short 2>/dev/null || kubectl version --client)${ENDCOLOR}"

if ! command -v k3d >/dev/null 2>&1; then
    sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    sleep 1
    sudo k3d cluster create --config confs/k3d-config.yaml
    sleep 1
    sudo kubectl apply -f confs/argocd/namespace.yaml
    sudo kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    sudo kubectl wait --for=condition=available deployment \
        -l app.kubernetes.io/name=argocd-server \
        -n argocd \
        --timeout=300s
    sudo kubectl patch configmap argocd-cmd-params-cm -n argocd \
        --type merge \
        -p '{"data":{"server.insecure":"true"}}'
    sudo kubectl rollout restart deployment argocd-server -n argocd
    sudo kubectl rollout status deployment argocd-server -n argocd --timeout=300s
    sudo kubectl apply -f confs/argocd/ingress.yaml
    sudo kubectl apply -f confs/argocd/argocd-app.yaml
fi
printf '%s\n' "${GREEN}$(k3d version)${ENDCOLOR}"

if ! command -v argocd >/dev/null 2>&1; then
    ARGOCD_SECRET=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d)

    sudo curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/download/v3.3.6/argocd-linux-amd64
    sudo chmod +x argocd
    sudo mv argocd /usr/local/bin/
    sudo argocd login argocd.local:8843 \
        --username "admin" \
        --password "$ARGOCD_SECRET" \
        --insecure
    sudo argocd account update-password \
        --current-password "$ARGOCD_SECRET" \
        --new-password "adminadmin"
    sudo kubectl delete secret argocd-initial-admin-secret -n argocd
fi
printf '%s\n' "${GREEN}$(argocd version --client)${ENDCOLOR}"
