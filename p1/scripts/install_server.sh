#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

TOKEN_PATH="/var/lib/rancher/k3s/server/node-token"
OUT_PATH="/vagrant/.node-token"

apt-get update -qq
apt-get install -y curl

if command -v k3s >/dev/null 2>&1; then
    echo "k3s is already installed"
else
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -s - \
        --write-kubeconfig-mode 644 \
        --node-ip "192.168.56.110" \
        --bind-address "192.168.56.110" \
        --advertise-address "192.168.56.110" \
        --cluster-init 
fi

for i in $(seq 1 120); do
    if [ -s "$TOKEN_PATH" ]; then
        cat $TOKEN_PATH > $OUT_PATH
        chown vagrant:vagrant "$OUT_PATH" || true
        break
    fi
    sleep 1
done

if [ ! -s "$OUT_PATH" ]; then
    echo "ERROR: node-token not found at $TOKEN_PATH after timeout" >&2
    exit 1
fi