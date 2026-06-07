#!/bin/sh

set -eu

. ./config

cleanup() {
  echo "cleanup came"
  trap - SIGINT SIGTERM
  kill -- -$$
  exit 0
}

trap cleanup SIGINT SIGTERM

i=0
while [ "$i" -lt "$CONTAINER_COUNT" ]; do
  sh -c "echo $((29050 + i)): \$(curl -s --socks5 127.0.0.1:$((29050 + i)) https://ifconfig.me)" &

  i=$((i + 1))
done

wait
