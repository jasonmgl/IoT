#!/bin/bash
set -euo pipefail

sudo rm -f /etc/apt/sources.list.d/docker.list    
sudo rm -f /etc/apt/keyrings/docker.gpg 
sudo apt remove -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-ce-rootless-extras docker-buildx-plugin
sudo rm -rf /var/lib/docker