{ config, lib, pkgs, ... }:
{
  home.pointerCursor = {
    package = pkgs.pantheon.elementary-icon-theme;
    name = "elementary";
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };

  home.file = {
    "${config.xdg.configHome}/autostart/ibus-daemon.desktop".text = "
[Desktop Entry]
Name=IBus Daemon
Comment=IBus Daemon
Type=Application
Exec=${pkgs.ibus}/bin/ibus-daemon --daemonize --desktop=pantheon --replace --xim
Categories=
Terminal=false
NoDisplay=true
StartupNotify=false";

    "${config.xdg.configHome}/autostart/monitor.desktop".text = "
[Desktop Entry]
Name=Monitor Indicators
Comment=Monitor Indicators
Type=Application
Exec=/run/current-system/sw/bin/com.github.stsdc.monitor --start-in-background
Icon=com.github.stsdc.monitor
Categories=
Terminal=false
StartupNotify=false";
  };
}
