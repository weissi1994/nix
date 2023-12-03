{config, username, pkgs, ...}:
{
  systemd.services.ModemManager.enable = true;
}
