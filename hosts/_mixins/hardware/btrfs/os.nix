{ config, hostname, inputs, lib, outputs, pkgs, os_disk, ... }:
{
  imports = [
    # Disko
    ./disks.nix
    inputs.disko.nixosModules.disko 
    { disko.devices.disk.os.device = lib.mkForce "${os_disk}"; }
  ];

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /mnt
    mount -t btrfs /dev/mapper/enc /mnt
    btrfs subvolume delete /mnt/root
    btrfs subvolume snapshot /mnt/root-blank /mnt/root
  '';
}
