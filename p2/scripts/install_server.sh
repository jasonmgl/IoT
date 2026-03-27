#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

launchPodAndService () {
    if ! kubectl get pod --ignore-not-found | grep -q "app$1"; then
        echo "launch pod $1"
        kubectl apply -f /vagrant/pods/app$1/app$1.yaml
        sleep 2
        kubectl apply -f /vagrant/pods/app$1/app$1-service.yaml
        sleep 2
    fi
}

launchIngress () {
    if ! kubectl get ingress apps --ignore-not-found >/dev/null 2>&1; then
        echo "launch ingress"
        kubectl apply -f /vagrant/pods/apps-ingress.yaml
    fi
}

initAndInstallK3s () {
    apt-get update -qq
    apt-get install -y curl

    if command -v k3s >/dev/null 2>&1; then
        echo "k3s is already installed on this system."
    else
        curl -sfL https://get.k3s.io | sh -s - \
            --write-kubeconfig-mode 644 \
            --node-ip "192.168.56.110" \
            --bind-address "192.168.56.110" \
            --advertise-address "192.168.56.110" \
            --cluster-init

        echo "waiting for k3s API to become ready..."
        until kubectl get nodes >/dev/null | grep -q "Ready"; do
            sleep 2
        done
    fi
}

waitForPod () {
    echo "wait for pod $1"
    kubectl wait pod -n default -l app=app$1 --for=condition=Ready --timeout=120s
}

initAndInstallK3s

for i in $(seq 1 3); do
    launchPodAndService "$i"
    waitForPod "$i"
done

launchIngress