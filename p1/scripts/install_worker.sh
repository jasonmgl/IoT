export DEBIAN_FRONTEND=noninteractive

TOKEN_PATH="/vagrant/.node-token"

apt-get update -qq
if command -v curl >/dev/null 2>&1; then
    echo "curl is already installed"
else
    apt-get install -y curl
fi

for i in $(seq 1 120); do
    if [ -s "$TOKEN_PATH" ]; then
        TOKEN="$(cat $TOKEN_PATH)"
        break
    fi
    sleep 1
done

if [ ! -s "$TOKEN_PATH" ]; then
    echo "ERROR: node-token not found after timeout" >&2
    exit 1
fi

if command -v k3s >/dev/null 2>&1; then
    echo "k3s is already installed on this system."
else
    curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$TOKEN sh -s - \
        --node-ip "192.168.56.111"
fi