#!/bin/sh

set -eu

. ./config

mkdir -p "$STORAGE_ROOT" "$RUN_ROOT"

podman --storage-driver=vfs \
  --root "$STORAGE_ROOT" \
  --runroot "$RUN_ROOT" \
  build -t "$IMAGE_NAME" . -f - <<'EOF'
FROM alpine:latest
RUN apk add --no-cache tor
EOF
