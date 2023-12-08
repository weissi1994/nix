{ config, hostname, inputs, lib, outputs, pkgs, os_disk, ... }:
{
  imports = [
    # Disko
    ./disks.nix
    inputs.disko.nixosModules.disko 
    { disko.devices.disk.os.device = lib.mkForce "${os_disk}"; }
  ];

  boot.supportedFilesystems = lib.mkForce [ "btrfs" "bcachefs" "cifs" "f2fs" "jfs" "ntfs" "reiserfs" "vfat" "xfs" ];
  boot.kernelPackages = pkgs.linuxPackages_testing;

  # TODO: convert to systemd unit https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/system/boot/systemd/initrd.nix
  # boot.initrd.postDeviceCommands = lib.mkAfter ''
  #   mkdir /mnt
  #   mount -t btrfs /dev/mapper/enc /mnt
  #   btrfs subvolume delete /mnt/root
  #   btrfs subvolume snapshot /mnt/root-blank /mnt/root
  # '';
}
