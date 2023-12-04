{ config, desktop, hostname, lib, pkgs, username, ... }: {
  imports = [ ] ++ lib.optionals (desktop != null) [
    ./gopass-ui.nix
  ];

  home.packages = with pkgs; [
    gopass
    gopass-hibp
    gopass-summon-provider
    summon
  ] ++ lib.optionals (desktop != null) [
    gopass-jsonapi
  ];
}
