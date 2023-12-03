{ config, inputs, lib, pkgs, platform, hostname, username, modulesPath, ... }:
{
  # Experimental: modem is loaded and technically functional, but sim not recognized 
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
  systemd.services.ModemManager.enable = true;
  hardware.usbWwan.enable=true;
  services.udev.packages = with pkgs; [ usb-modeswitch-data ];
}
