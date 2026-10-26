#!/bin/sh

set -eu

. ./config

[ -n "${PODMAN_TOR_UNIT:-}" ] || exec systemd-run --user --pty --same-dir --quiet --collect \
  -p Delegate=yes -E PODMAN_TOR_UNIT=1 "$(realpath "$0")"

for i in $(seq 0 $((CONTAINER_COUNT - 1))); do
  podman --storage-driver=vfs --root "$STORAGE_ROOT" --runroot "$RUN_ROOT" \
    run --rm --replace --cgroups=split --name "tor$i" -p $((29050 + i)):9050 \
    "$IMAGE_NAME" tor --SocksPort 0.0.0.0:9050 &
done

wait
