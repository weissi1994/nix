{ config, pkgs, lib, fetchurl, ... }:
{
  imports = [
    ../../../services/wireguard.nix
  ];

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  home.file.".config/Yubico/u2f_keys".source = ./u2f_keys.stay;
  wayland.windowManager.sway = {
    config = {
      output = {
        eDP-1 = {
          resolution = "1920x1080";
          position = "0,0";
        };
      };
      startup = lib.mkForce [
        # Note taking app
        { command = "obsidian"; }
        # Notification daemon
        { command = "swaync"; }
        # Slack
        { command = "slack"; }
        # Web browsing
        { command = "NIXOS_OZONE_WL=1 google-chrome-stable"; }
        # Chatting
        { command = "telegram-desktop"; }
        # Polkit
        { command = "/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1"; }
        # Idle
        { command = "$HOME/.config/sway/idle.sh"; }
      ];
    };
    extraConfig = ''
      for_window [urgent="latest"] focus
      focus_on_window_activation   focus

      workspace 1 output "eDP-1"

      assign [app_id="org.telegram.desktop"] workspace number 1
      assign [class="obsidian"] workspace number 1
      assign [class="Slack"] workspace number 1

      for_window [app_id="(?i)(?:blueman-manager|azote|gnome-disks|opensnitch_ui)"] floating enable
      for_window [app_id="(?i)(?:pavucontrol|nm-connection-editor|gsimplecal|galculator)"] floating enable
      for_window [app_id="(?i)(?:firefox|chromium)"] border none
      for_window [title="(?i)(?:copying|deleting|moving)"] floating enable

      popup_during_fullscreen smart
    '';
  };
}
