#!/bin/sh
set -eu
cd "$(dirname "$0")"

# Build only the committed lab files and transfer the image via the synced folder.
revision=$(git rev-parse --verify HEAD)
repo_root=$(git rev-parse --show-toplevel)
lab_path=$(git rev-parse --show-prefix)
guest_arch=$(vagrant ssh -c 'uname -m')
guest_arch=$(printf '%s' "$guest_arch" | tr -d '\r')
case "$guest_arch" in
    x86_64) platform=linux/amd64 ;;
    aarch64) platform=linux/arm64 ;;
    *) printf 'Unsupported guest architecture: %s\n' "$guest_arch" >&2; exit 1 ;;
esac

image="docker.io/library/grafana-plugin-lab:$revision"
mkdir -p .lab
transfer=$(mktemp -d .lab/deploy.XXXXXXXX)
trap 'rm -rf "$transfer"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
git -C "$repo_root" archive "$revision:${lab_path%/}" > "$transfer/context.tar"
docker build --platform "$platform" -t "$image" - < "$transfer/context.tar"
docker save -o "$transfer/image.tar" "$image"

vagrant ssh -c "sudo k3s ctr images import --platform '$platform' '/vagrant/$transfer/image.tar'"
vagrant ssh -c "sudo k3s kubectl -n grafana set image deployment/grafana grafana='$image' &&
    sudo k3s kubectl -n grafana rollout status deployment/grafana --timeout=300s"
printf 'Deployed commit %s. Open /d/plugin-hello/plugin-lab in Grafana.\n' "$revision"
