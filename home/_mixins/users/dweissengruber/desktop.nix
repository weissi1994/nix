{ config, lib, pkgs, username, ... }:
{
  home.packages = with pkgs; [
    slack
  ];
}
