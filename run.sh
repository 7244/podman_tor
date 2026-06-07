#!/bin/sh

set -eu

. ./config

cleanup() {
  echo "cleanup came"
  podman --storage-driver=vfs \
    --root "$STORAGE_ROOT" \
    --runroot "$RUN_ROOT" \
    stop --all
  wait
  echo ""
  exit 0
}

trap cleanup SIGINT SIGTERM

i=0
while [ "$i" -lt "$CONTAINER_COUNT" ]; do
  podman \
    --storage-driver=vfs \
    --root "$STORAGE_ROOT" \
    --runroot "$RUN_ROOT" \
    run --rm -p $((29050 + i)):9050 \
    "$IMAGE_NAME" \
    sh -c "(echo SocksPort 0.0.0.0:9050 > /etc/tor/torrc) && tor" &

  i=$((i + 1))
done

wait
