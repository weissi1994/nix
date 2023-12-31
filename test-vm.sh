#!/run/current-system/sw/bin/bash

HOST=${1:?Please set host}

rm -f "./${HOST}.qcow2"

nix build .#nixosConfigurations.$HOST.config.system.build.vm

QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-xeus-vm &

echo "connect with: ssh -p 2222 ion@127.0.0.1"
