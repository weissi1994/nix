# Motherboard: ROG Crosshair VIII Impact
# CPU:         AMD Ryzen 9 5950X
# GPU:         NVIDIA RTX 3080Ti
# RAM:         64GB DDR4
# NVME:        2TB Corsair MP600
# NVME:        4TB Corsair MP600
# SATA:        4TB Samsung 870 QVO
# SATA:        4TB Samsung 870 QVO

{ config, inputs, lib, pkgs, platform, hostname, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    #inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    #inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    (import ../_mixins/hardware/btrfs/disks.nix {
      disks = ["/dev/disk/by-id/wwn-0x5002538e4084d7cc"];
      hostname = "${hostname}";
    })
    ../_mixins/hardware/systemd-boot.nix
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

  #hardware = {
  #  nvidia = {
  #    prime.offload.enable = false;
  #  };
  #  cpu.amd.updateMicrocode = true;
  #};

  # services = {
  #   hardware.openrgb = {
  #     enable = true;
  #     motherboard = "amd";
  #     package = pkgs.openrgb-with-all-plugins;
  #   };
  # };

  # swapDevices = [{
  #   device = "/swap/swapfile";
  #   size = 8196;
  # }];

  nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}

