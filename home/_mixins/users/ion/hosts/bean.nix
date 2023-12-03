{ config, pkgs, fetchurl, ... }:
{
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  home.file.".config/Yubico/u2f_keys".source = ./u2f_keys.bean;
  wayland.windowManager.sway = {
    config = {
      output = {
        eDP-1 = {
          resolution = "1920x1080";
          position = "0,0";
        };
      };
    };
    extraConfig = ''
      for_window [urgent="latest"] focus
      focus_on_window_activation   focus

      workspace 1 output "eDP-1"

      assign [app_id="org.telegram.desktop"] workspace number 1
      assign [class="obsidian"] workspace number 1
      assign [class="Spotify"] workspace number 10

      for_window [app_id="(?i)(?:blueman-manager|azote|gnome-disks|opensnitch_ui)"] floating enable
      for_window [app_id="(?i)(?:pavucontrol|nm-connection-editor|gsimplecal|galculator)"] floating enable
      for_window [app_id="(?i)(?:firefox|chromium)"] border none
      for_window [title="(?i)(?:copying|deleting|moving)"] floating enable

      popup_during_fullscreen smart
    '';
  };
}
