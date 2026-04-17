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

sudo apt-get update -qq
sudo apt-get install -yqq ca-certificates curl >/dev/null
sudo install -m 0755 -d /etc/apt/keyrings

if ! command -v docker >/dev/null 2>&1; then
    sudo sh scripts/get-docker.sh
fi
printf '%s\n' "${GREEN}Docker Version: $(docker version --format '{{.Server.Version}}')${ENDCOLOR}"

if ! command -v kubectl >/dev/null 2>&1; then
    sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo chmod +x kubectl && mv kubectl /usr/local/bin/
fi
printf '%s\n' "${GREEN}Kubectl: $(kubectl version --client --short 2>/dev/null || kubectl version --client)${ENDCOLOR}"

if ! command -v k3d >/dev/null 2>&1; then
    sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    sleep 1
    sudo k3d cluster create --config confs/k3d-config.yaml
fi
printf '%s\n' "${GREEN}$(k3d version)${ENDCOLOR}"

if ! command -v helm >/dev/null 2>&1; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    sudo helm repo add gitlab http://charts.gitlab.io/
    sudo helm repo add argo https://argoproj.github.io/argo-helm
    sudo helm repo update
    sudo helm upgrade --install argo-cd argo/argo-cd --version 9.5.2 --namespace argocd --create-namespace --wait -f confs/argocd/values.yaml --timeout 10m
    sudo kubectl apply -f confs/argocd/argocd-app.yaml
    sudo kubectl create namespace gitlab || true
    sudo kubectl -n gitlab create secret generic gitlab-gitlab-initial-root-password --from-literal=password='RootRootRoot'
    sudo kubectl -n gitlab create secret generic gitlab-minio-secret --from-literal=accesskey='admin' --from-literal=secretkey='adminadmin'
    sleep 1
    sudo helm upgrade --install gitlab gitlab/gitlab --version 9.10.3 --namespace gitlab --wait -f confs/gitlab/values.yaml --timeout 10m
fi
printf '%s\n' "${GREEN}Helm: $(helm version --short)${ENDCOLOR}"

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
