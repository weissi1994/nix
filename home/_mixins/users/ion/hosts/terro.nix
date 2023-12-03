{ config, pkgs, fetchurl, ... }:
{
  home.file.".config/Yubico/u2f_keys".source = ./u2f_keys.terro;

  wayland.windowManager.sway = {
    config = {
      output = {
        DP-1 = {
          resolution = "2560x1440";
          position = "0,0";
        };
        DP-2 = {
          resolution = "2560x1440";
          position = "2560,400";
        };
        DP-3 = {
          resolution = "2560x1440";
          position = "5120,0";
          #transform = "90";
        };
      };
    };
    extraConfig = ''
      for_window [urgent="latest"] focus
      focus_on_window_activation   focus

      workspace 1 output "DP-1"
      workspace 2 output "DP-3"
      workspace 3 output "DP-2"

      assign [app_id="org.telegram.desktop"] workspace number 2
      assign [class="obsidian"] workspace number 2
      assign [class="Spotify"] workspace number 2

      for_window [app_id="(?i)(?:blueman-manager|azote|gnome-disks|opensnitch_ui)"] floating enable
      for_window [app_id="(?i)(?:pavucontrol|nm-connection-editor|gsimplecal|galculator)"] floating enable
      for_window [app_id="(?i)(?:firefox|chromium)"] border none
      for_window [title="(?i)(?:copying|deleting|moving)"] floating enable

      popup_during_fullscreen smart
    '';
  };
}
