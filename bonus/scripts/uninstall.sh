#!/bin/bash

DEBIAN_FRONTEND=noninteractive

set -uo pipefail

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

printf '%s\n' "${GREEN}             .__                 __         .__  .__              .__     ${ENDCOLOR}"
printf '%s\n' "${GREEN} __ __  ____ |__| ____   _______/  |______  |  | |  |        _____|  |__  ${ENDCOLOR}"
printf '%s\n' "${GREEN}|  |  \/    \|  |/    \ /  ___/\   __\__  \ |  | |  |       /  ___/  |  \ ${ENDCOLOR}"
printf '%s\n' "${GREEN}|  |  /   |  \  |   |  \\___ \  |  |  / __ \|  |_|  |__     \___ \|   Y  \ ${ENDCOLOR}"
printf '%s\n' "${GREEN}|____/|___|  /__|___|  /____  > |__| |____  /____/____/ /\ /____  >___|  / ${ENDCOLOR}"
printf '%s\n' "${GREEN}           \/        \/     \/            \/            \/      \/     \/ ${ENDCOLOR}"

read -rp 'Do you want to uninstall helm ? [y/n] ' answer
case "$answer" in
    y|Y)
        if command -v helm >/dev/null 2>&1; then
            if sudo kubectl version --request-timeout=2s >/dev/null 2>&1; then
                sudo helm uninstall gitlab -n gitlab --ignore-not-found || true
                sudo helm uninstall argocd -n argocd --ignore-not-found || true
            else
                printf '%s\n' "${RED}Cluster unreachable, skip helm releases cleanup${ENDCOLOR}"
            fi
            sudo rm -f /usr/local/bin/helm
        fi
        printf '%s\n' "${GREEN}Helm uninstalled${ENDCOLOR}"
        ;;
    n|N)
        printf '%s\n' "${RED}Skip uninstall helm${ENDCOLOR}"
        ;;
    *)
        printf '%s\n' "${RED}Invalid answer: use y or n${ENDCOLOR}"
        ;;
esac

read -rp 'Do you want to uninstall kubectl ? [y/n] ' answer
case "$answer" in
    y|Y)
        if command -v kubectl >/dev/null 2>&1; then
            if sudo kubectl version --request-timeout=2s >/dev/null 2>&1; then
                sudo kubectl delete pvc -n gitlab --all || true
                sudo kubectl delete secret -n gitlab --all || true
                sudo kubectl delete namespace gitlab --ignore-not-found --timeout=60s || true
                sudo kubectl delete namespace argocd --ignore-not-found --timeout=60s || true
            else
                printf '%s\n' "${RED}Cluster unreachable, skip namespaces cleanup${ENDCOLOR}"
            fi
            sudo rm -f /usr/local/bin/kubectl
        fi
        printf '%s\n' "${GREEN}Kubectl uninstalled${ENDCOLOR}"
        ;;
    n|N)
        printf '%s\n' "${RED}Skip uninstall kubectl${ENDCOLOR}"
        ;;
    *)
        printf '%s\n' "${RED}Invalid answer: use y or n${ENDCOLOR}"
        ;;
esac

read -rp 'Do you want to uninstall k3d ? [y/n] ' answer
case "$answer" in
    y|Y)
        if command -v k3d >/dev/null 2>&1; then
            sudo k3d cluster delete bonus >/dev/null 2>&1
		    sudo rm -f /usr/local/bin/k3d
        fi
        printf '%s\n' "${GREEN}K3d uninstalled${ENDCOLOR}"
        ;;
    n|N)
        printf '%s\n' "${RED}Skip uninstall k3d${ENDCOLOR}"
        ;;
    *)
        printf '%s\n' "${RED}Invalid answer: use y or n${ENDCOLOR}"
        ;;
esac

read -rp 'Do you want to uninstall argocd cli ? [y/n] ' answer
case "$answer" in
    y|Y)
        if command -v argocd >/dev/null 2>&1; then
            sudo rm -f /usr/local/bin/argocd
        fi
        printf '%s\n' "${GREEN}Argocd cli uninstalled${ENDCOLOR}"
        ;;
    n|N)
        printf '%s\n' "${RED}Skip uninstall argocd cli${ENDCOLOR}"
        ;;
    *)
        printf '%s\n' "${RED}Invalid answer: use y or n${ENDCOLOR}"
        ;;
esac

read -rp 'Do you want to uninstall docker ? [y/n] ' answer
case "$answer" in
    y|Y)
        if command -v docker >/dev/null 2>&1; then
            sudo bash scripts/remove-docker.sh
        fi
        printf '%s\n' "${GREEN}Docker uninstalled${ENDCOLOR}"
        ;;
    n|N)
        printf '%s\n' "${RED}Skip uninstall docker${ENDCOLOR}"
        ;;
    *)
        printf '%s\n' "${RED}Invalid answer: use y or n${ENDCOLOR}"
        ;;
esac

if grep -q "${ARGOCD_HOSTNAME:-__none__}" /etc/hosts 2>/dev/null; then
    sudo sed -i "/$ARGOCD_HOSTNAME/d" /etc/hosts
fi