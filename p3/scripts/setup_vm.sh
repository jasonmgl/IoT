#!/bin/bash
set -euo pipefail

sudo apt-get update -qq
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings

if ! command -v docker >/dev/null 2>&1;  then
    sudo sh scripts/get-docker.sh
fi
echo "Docker Version : $(sudo docker version --format '{{.Server.Version}}')"

if ! command -v kubectl >/dev/null 2>&1;  then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl && sudo mv kubectl /usr/local/bin/
fi
echo "Kubectl : $(kubectl version --client --short 2>/dev/null || kubectl version --client)"

if ! command -v k3d >/dev/null 2>&1;  then
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi
k3d version
