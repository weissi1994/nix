#!/bin/bash

HOST=${1:-Please set host}

nix build .#nixosConfigurations.$HOST.config.system.build.vm

QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-xeus-vm

echo "connect with: ssh -p 2222 ion@127.0.0.1"
