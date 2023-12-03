{config, username, pkgs, ...}:
{
  imports = [
    ./bluetooth.nix
    ./touchpad.nix
    ./wifi.nix
  ];

  # Don't suspend if lid is closed with computer on power.
  # services.logind.lidSwitchExternalPower = "lock";
  # suspend-then-hibernate to survive through critical power level.
  services.logind.lidSwitch = "suspend-then-hibernate";
}
