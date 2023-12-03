{ config, pkgs, lib, ... }:
let
  colorScheme = import ../../color-schemes/catpuchino.nix;
  font = "FiraGO";
in
{
  home.packages = with pkgs; [
    jq
    pamixer
    pavucontrol
    gopsuinfo
  ];

  programs.waybar = {
    enable = true;
    settings = [
      {
        name = "top";
        layer = "top"; # Waybar at top layer
        position = "top"; # Waybar position (top|bottom|left|right)
        height = 32; # Waybar height
        spacing = 4;
        # Choose the order of the modules
        modules-left = [ "custom/launcher" "sway/workspaces" "sway/window" "sway/mode" ];
        modules-center = [ "custom/clock" ];
        modules-right = [ "tray" "pulseaudio" "battery" "backlight" "network" "custom/notification" "custom/power" ];
        "sway/workspaces" = {
          disable-scroll = true;
          disable-markup = false;
          all-outputs = true;
          format = "  {icon}  ";
          #format ="{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
            "focused" = "";
            "default" = "";
          };
        };
        "custom/launcher" = {
          format = " ";
          on-click = "nwggrid -b '${colorScheme.background}'";
        };
        "custom/notification" = {
          tooltip = false;
          format = " {} {icon}  ";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
        "custom/power" = {
          format = " ⏻  ";
          on-click = "nwgbar -b '${colorScheme.background}'";
          tooltip = false;
        };
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        "sway/language" = {
          format = "{}";
          max-length = 50;
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        "tray" = {
          icon-size = 21;
          spacing = 10;
        };
        "custom/clock" = {
          exec = "date +'%d. %b %H:%M'";
          interval = 10;
        };
        "backlight" = {
          # device = "acpi_video1";
          format = " {percent}% {icon}  ";
          states = [ "0" "50" ];
        };
        "pulseaudio" = {
          #"scroll-step" = 1;
          "format" = "{volume}% {icon}";
          "format-bluetooth" = "{volume}% {icon}";
          "format-muted" = "";
          "format-icons" = {
            "headphones" = "";
            "handsfree" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [ "" "" ];
          };
          "on-click" = "pavucontrol";
        };
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = " {capacity}% {icon}  ";
          # "format-good" = ""; # An empty format will hide the module
          # "format-full" = "";
          format-icons = [ "" "" "" "" "" ];
        };
        "network" = {
          # "interface" = "wlp2s0"; # (Optional) To force the use of this interface
          "format-wifi" = "{essid} ({signalStrength}%)  ";
          "format-ethernet" = "{ifname} = {ipaddr}/{cidr}  ";
          "format-disconnected" = "Disconnected ⚠ ";
          "interval" = 7;
        };
        "bluetooth" = {
          format = "<b>{icon}</b>";
          format-alt = "{status} {icon}";
          interval = 30;
          format-icons = {
            "enabled" = "";
            "disabled" = "";
          };
          tooltip-format = "{}";
        };
      }
      {
        name = "bottom";
        layer = "top"; # Waybar at top layer
        position = "bottom"; # Waybar position (top|bottom|left|right)
        height = 32; # Waybar height
        spacing = 20;
        # Choose the order of the modules
        modules-left = [ "custom/screenshot" "custom/color-picker" "custom/emoji-picker" ];
        modules-center = [ ];
        modules-right = [ "cpu" "memory" "disk" "temperature" ];
        # modules-right = [ "custom/gopsuinfo" ];
        "cpu" = {
          format = "{usage}% ";
        };
        "memory" = {
          format = "{}% ";
          format-alt = " {used:0.1f}G";
        };
        "disk" = {
          format = "{}% ";
          tooltip-format = "{used} / {total} used";
        };
        "temperature" = {
          # thermal-zone = 2;
          "hwmon-path" = "/sys/class/hwmon/hwmon1/temp1_input";
          critical-threshold = 80;
          # format-critical = "{temperatureC}°C ";
          format = "{temperatureC}°C  ";
        };
        "custom/gopsuinfo" = {
          exec = "gopsuinfo -c gatmnu";
          interval = 1;
        };
        "custom/screenshot" = {
          format = " ";
          tooltip-format = "Take a screenshot";
          on-click = "sh $HOME/.config/sway/screenshot.sh area";
          on-click-middle = "sh $HOME/.config/sway/screenshot.sh window";
          on-click-right = "sh $HOME/.config/sway/screenshot.sh output";
        };
        "custom/color-picker" = {
          format = "  ";
          tooltip-format = "Pick a color on the screen(s)";
          on-click = "sh $HOME/.config/sway/color-picker.sh";
        };
        "custom/emoji-picker" = {
          format = "🏳️‍🌈";
          tooltip = "true";
          tooltip-format = "Pick an emoji and copy it to the clipboard";
          on-click = "wofi-emoji";
        };
      }
    ];
    style = ''
      * {
        font-family: "${font} Medium";
        font-size: 13px;
        background-color: ${colorScheme.background};
        color: ${colorScheme.foreground}
      }

      window#waybar {
        background: transparent;
        color: white;
      }

      #window {
        font-weight: bold;
        font-family: "${font}";
      }

      #custom-notification {
        font-family: "NotoSansMono Nerd Font";
      }

      #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: white;
        border-top: 2px solid transparent;
      }

      #custom-power {
        padding-right: 5px;
      }

      #workspaces button.focused {
        color: #c9545d;
        border-top: 2px solid #c9545d;
      }

      #mode {
        background: #64727D;
        border-bottom: 3px solid white;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray, #mode {
        padding: 0 3px;
        margin: 0 2px;
      }

      #clock {
        font-weight: bold;
      }

      #battery {
      }

      #battery icon {
        color: red;
      }

      #battery.charging {
      }

      #battery.warning:not(.charging) {
        color: white;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #cpu {
      }

      #memory {
      }

      #network {
      }

      #network.disconnected {
        background: #f53c3c;
      }

      #pulseaudio {
      }

      #pulseaudio.muted {
      }

      #tray {
      }
    '';
  };
}

