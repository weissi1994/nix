{ config, inputs, lib, pkgs, platform, hostname, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ../_mixins/hardware/systemd-boot.nix
    ../_mixins/services/pipewire.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.swraid = {
    enable = true;
    mdadmConf = ''
DEVICE partitions
ARRAY /dev/md/0 metadata=1.2 name=xeus:0 UUID=0239ddb6:f3b2e5e2:0bfe9532:875ff802
MAILADDR ion@n0de.biz
PROGRAM /run/current-system/sw/sbin/handle-mdadm-events
    '';
  };

  fileSystems."/srv" =
  { device = "/dev/md0";
    fsType = "ext4";
    options = [ "rw" "relatime" ];
  }; 

  nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}

