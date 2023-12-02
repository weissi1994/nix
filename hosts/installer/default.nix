{ config, inputs, lib, pkgs, platform, ... }:
{
  imports = [
    # (modulesPath + "/profiles/installation-device.nix")
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ../_mixins/hardware/systemd-boot.nix
    ../_mixins/services/pipewire.nix
  ];

  swapDevices = [{
    device = "/swap";
    size = 1024;
  }];

  nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}
