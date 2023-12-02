{config, username, pkgs, ...}:
{
  environment = {
    systemPackages = with pkgs; [
      ifwifi
    ];
  };

  # Network
  networking = {
    networkmanager.enable = true;
  };
  systemd.services.ModemManager.enable = true;

  programs.nm-applet = {
    enable = true;
    indicator = false;
  };

  # Touchpad
  services = {
    xserver = {
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
        touchpad.middleEmulation = true;
        touchpad.tapping = true;
      };
    };
  };

  hardware.bluetooth = {
    enable = true;
    disabledPlugins = [ "sap" ];
  };

  # Don't suspend if lid is closed with computer on power.
  # services.logind.lidSwitchExternalPower = "lock";
  # suspend-then-hibernate to survive through critical power level.
  services.logind.lidSwitch = "suspend-then-hibernate";
}
