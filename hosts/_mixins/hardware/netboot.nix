{ config, lib, pkgs, ... }:
{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";

      extraFiles = { "ipxe.efi" = "${pkgs.ipxe}/ipxe.efi"; };
      extraEntries = ''
        menuentry "Reinstall via iPXE" {
          chainloader /ipxe.efi
        }
      '';
    };
  };
}
