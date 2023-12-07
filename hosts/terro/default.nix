# ╭─  Micro-Star International Co., Ltd B450 GAMING PLUS MAX (MS-7B86) 
# ├─  AMD Ryzen 9 3900X (24)
# ├─  64GB - 4x 16GB @ 3600 MT/s
# ├─  NVIDIA GeForce RTX 2070 SUPER 
# ╰─  2560x1440, 2560x1440, 2560x1440
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
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

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

