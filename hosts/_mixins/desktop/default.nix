{ inputs, desktop, lib, pkgs, ... }: {
  imports = [
    ../services/cups.nix
    ../programs/networking.nix
    ../programs/ctf.nix
    ../firewall
  ]
  ++ lib.optional (builtins.pathExists (./. + "/${desktop}.nix")) ./${desktop}.nix;

  boot = {
    kernelParams = [ "quiet" "vt.global_cursor_default=0" "mitigations=off" ];
    plymouth.enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  programs.dconf.enable = true;

  # Disable xterm
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
}
