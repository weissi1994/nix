{ inputs, lib, config, pkgs, ... }:
{
  # iPXE Boot server 
  services.pixiecore = {
    enable = true;
    openFirewall = true;
    dhcpNoBind = true;
    kernel = "https://boot.netboot.xyz";
    debug = true;
  };
}
