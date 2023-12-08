{ config, inputs, lib, pkgs, platform, ... }:
{
  imports = [
    # (modulesPath + "/profiles/installation-device.nix")
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ../_mixins/hardware/systemd-boot.nix
    ../_mixins/services/pipewire.nix
  ];

  boot.supportedFilesystems = lib.mkForce [ "btrfs" "bcachefs" "cifs" "f2fs" "jfs" "ntfs" "reiserfs" "vfat" "xfs" ];
  boot.kernelPackages = pkgs.linuxPackages_testing;
  services.openssh.settings.PermitRootLogin = "yes";

  swapDevices = [{
    device = "/swap";
    size = 1024;
  }];

  nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}
