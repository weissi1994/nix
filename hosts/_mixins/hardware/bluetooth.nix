{config, username, pkgs, ...}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    disabledPlugins = [ "sap" ];
  };

  services.blueman.enable = true;
}
