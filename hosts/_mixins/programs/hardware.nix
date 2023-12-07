{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [
    inxi
    dmidecode
  ];
}
