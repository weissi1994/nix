{ config, lib, pkgs, ... }:
{
  imports = [
    ./sway
    ./waybar
    ./terminal
    ./nvim
  ];
}
