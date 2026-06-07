#!/bin/bash

set -eu

. ./config

cleanup() {
  echo "cleanup came"
  trap - SIGINT SIGTERM
  kill -- -$$
  exit 0
}

trap cleanup SIGINT SIGTERM

for ((i=0; i<$CONTAINER_COUNT; i++)); do
  sh -c "echo $((29050 + i)): \$(curl -s --socks5 127.0.0.1:$((29050 + i)) https://ifconfig.me)" &
done

wait