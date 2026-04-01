#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

launchPodAndService () {
    if ! kubectl get pod --ignore-not-found | grep -q "app$1"; then
        kubectl apply -f /vagrant/pods/app$1/app$1.yaml
        sleep 1
        kubectl apply -f /vagrant/pods/app$1/app$1-service.yaml
        sleep 1
    fi
}

launchIngress () {
    if ! kubectl get ingress --ignore-not-found | grep -q "apps"; then
        kubectl apply -f /vagrant/pods/apps-ingress.yaml
        sleep 1
    fi
}

installK3s () {
    if command -v k3s >/dev/null 2>&1; then
        echo "k3s is already installed"
    else
        curl -sfL https://get.k3s.io | sh -s - \
            --write-kubeconfig-mode 644 \
            --node-ip "192.168.56.110" \
            --bind-address "192.168.56.110" \
            --advertise-address "192.168.56.110" \
            --cluster-init
    fi
}

waitForPod () {

    until kubectl get pods --ignore-not-found | grep -q "app$1"; do
        continue
    done
    kubectl wait pod -l app=app$1 --for=condition=Ready --timeout=120s >/dev/null
}

boot () {
    apt-get update -qq
    apt-get install -y curl
    installK3s
    for i in $(seq 1 3); do
        launchPodAndService "$i"
        waitForPod "$i"
    done
    launchIngress
}

boot