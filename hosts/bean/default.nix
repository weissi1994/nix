{ config, inputs, lib, pkgs, platform, hostname, username, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    (import ../_mixins/hardware/btrfs/disks.nix {
      disks = ["/dev/disk/by-id/nvme-eui.5cd2e42a8140cf60"];
      hostname = "${hostname}";
    })
    ../_mixins/hardware/laptop.nix
    ../_mixins/hardware/systemd-boot.nix
    ../_mixins/services/pipewire.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # netkit.xmm7360 = {
  #   enable = true;
  #   autoStart = true;
  #   config = {
  #     apn = "internet.t-mobile.at"; #your APN here
  #     nodefaultroute = false; # Setup default route so laptop uses 4G LTE when Wi-Fi is unavailable
  #     noresolv = true; # Don't contaminate my DNS config
  #     dbus = true;
  #   };
  #   package = pkgs.netkit.xmm7360-pci_latest;
  # };

  boot.kernelParams = [ "quiet" "udev.log_level=0" ];
  boot.plymouth.enable = true;
  boot.plymouth.theme = "bgrt";
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 0;

  hardware.enableRedistributableFirmware = true;

  # Update Intel CPU Microcode
  hardware.cpu.intel.updateMicrocode = true;

  # Intel UHD 620 Hardware Acceleration
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver # only available starting nixos-19.03 or the current nixos-unstable
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}

