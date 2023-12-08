{ pkgs, lib, ... }:
let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };

in
{
  imports = [
    ./programs/steam.nix
  ];

  #------------------------------------------
  # GDM wayland only
  #------------------------------------------
  # https://github.com/NixOS/nixpkgs/issues/57602#issuecomment-657762138

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  security.polkit.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock # lockscreen
      swayidle
      foot # default terminal (for iso)
      xwayland # for legacy apps
      waybar # status bar
      swaynotificationcenter # notification daemon
      kanshi # autorandr
      dmenu
      wofi # replacement for dmenu
      brightnessctl
      gammastep # make it red at night!
      sway-contrib.grimshot # screenshots
      swayr

      gnome.gnome-terminal
      gnome.gnome-system-monitor
      mate.caja
      gnome.nautilus
      evince

      # https://discourse.nixos.org/t/some-lose-ends-for-sway-on-nixos-which-we-should-fix/17728/2?u=senorsmile
      gnome3.adwaita-icon-theme # default gnome cursors
      glib                      # gsettings
      dracula-theme             # gtk theme (dark)
    ];
  };

  systemd.packages = [ pkgs.swaynotificationcenter ];

  services = {
    dbus.enable = true;
    dbus.packages = [ pkgs.swaynotificationcenter pkgs.gcr ];
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
        gdm.wayland = true;
      };
    };
  };
}
