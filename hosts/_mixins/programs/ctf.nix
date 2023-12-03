{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [
    gdb
    gef
    pwntools
  ];
}
