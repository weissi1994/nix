{ config, inputs, lib, pkgs, platform, hostname, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ../_mixins/hardware/systemd-boot.nix
    ../_mixins/hardware/nvidia.nix
    ../_mixins/services/pipewire.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Quiet boot with splash screen
  boot.blacklistedKernelModules = [ "ucsi_ccg" ];
  boot.kernelParams = [ "quiet" "udev.log_level=0" ];
  boot.plymouth.enable = true;
  boot.plymouth.theme = "bgrt";
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 0;

  hardware = {
    nvidia = {
      prime.offload.enable = false;
    };
  };

  # services = {
  #   hardware.openrgb = {
  #     enable = true;
  #     motherboard = "amd";
  #     package = pkgs.openrgb-with-all-plugins;
  #   };
  # };

  nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}

