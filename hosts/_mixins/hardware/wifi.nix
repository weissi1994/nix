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
}
