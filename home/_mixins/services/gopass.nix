{ config, desktop, hostname, lib, pkgs, username, ... }: {
  imports = [ ] ++ lib.optionals (desktop != null) [
    ./gopass-ui.nix
  ];

  home.packages = with pkgs; [
    gopass
    gopass-hibp
  ] ++ lib.optionals (desktop != null) [
    gopass-jsonapi
  ];
}
