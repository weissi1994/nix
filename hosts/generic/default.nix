{ config, inputs, lib, pkgs, platform, hostname, username, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # inputs.nixos-hardware.nixosModules.common-cpu-intel
    # inputs.nixos-hardware.nixosModules.common-cpu-amd
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    (import ../_mixins/hardware/btrfs/disks.nix {
      disks = ["/dev/disk/by-id/CHANGE_ME"];
      hostname = "${hostname}";
    })
    # ../_mixins/hardware/gpu.nix
    # ../_mixins/hardware/laptop.nix
    ../_mixins/hardware/systemd-boot.nix
    ../_mixins/services/pipewire.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Add host specific configs here
  nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}

