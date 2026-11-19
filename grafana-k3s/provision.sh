#!/bin/sh
set -eu

installer=$(mktemp)
trap 'rm -f "$installer"' EXIT
curl -fsSL https://get.k3s.io -o "$installer"
INSTALL_K3S_VERSION='v1.35.9+k3s1' sh "$installer" server \
    --disable traefik --disable servicelb --disable metrics-server

# The API can respond before kubelet has registered this node.
node_name=$(hostname -s)
printf 'Waiting for K3s node %s to register.\n' "$node_name"
attempt=0
until k3s kubectl --request-timeout=5s get node "$node_name" >/dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [ "$attempt" -ge 60 ]; then
        printf 'K3s node %s did not register.\n' "$node_name" >&2
        k3s kubectl --request-timeout=5s get nodes -o wide >&2 || true
        exit 1
    fi
    sleep 2
done
k3s kubectl wait --for=condition=Ready "node/$node_name" --timeout=180s
k3s kubectl apply -f /vagrant/k8s/resources.yaml

if ! k3s kubectl -n grafana get secret grafana-admin >/dev/null; then
    k3s kubectl -n grafana create secret generic grafana-admin \
        --from-literal=password="$(openssl rand -hex 24)"
fi

# Preserve the running plugin image when applying workload changes.
image=$(k3s kubectl -n grafana get deployment grafana --ignore-not-found \
    -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ -n "$image" ]; then
    k3s kubectl set image --local -f /vagrant/k8s/deployment.yaml "grafana=$image" -o yaml > "$installer"
    k3s kubectl apply -f "$installer"
else
    k3s kubectl apply -f /vagrant/k8s/deployment.yaml
fi
k3s kubectl -n grafana rollout status deployment/grafana --timeout=300s
