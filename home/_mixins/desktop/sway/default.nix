{ config, lib, pkgs, username, fetchurl, ... }:
let
  colorScheme = import ../../color-schemes/catpuchino.nix;
  background = ../background.png;
  #background = builtins.fetchurl {
  #  url = https://raw.githubusercontent.com/papojari/nixos-artwork/master/wallpapers/nix-wallpaper-3d-showcase-3840x2160.png;
  #  sha256 = "35376f1c95424580c3d3c3f1843b047789be389bff689285bf1948fe36d84779";
  #};
  modifier = "Mod4";
  left = "Left";
  down = "Down";
  up = "Up";
  right = "Right";
  resizeAmount = "30px";
  menu = "nwggrid -b '${colorScheme.background}'";
  filebrowser = "nemo";
  webbrowser = "brave";
  webbrowserPersistent = "NIXOS_OZONE_WL=1 google-chrome-stable";
  musicplayer = "spotify";
in
{
  home = {
    file = {
      ".config/sway/background.png".source = background;
      ".config/sway/idle.sh".source = ./idle.sh;
      ".config/sway/color-picker.sh".source = builtins.fetchurl {
        url = https://raw.githubusercontent.com/jgmdev/wl-color-picker/main/wl-color-picker.sh;
        sha256 = "0f3i86q9vx0665h2wvmmnfccd85kav4d9kinfzdnqpnh96iqsjkg";
      };
      ".config/sway/screenshot.sh".source = ./screenshot.sh;
      ".config/sway/lock.sh".source = ./lock.sh;
      ".config/nwg-launchers/nwgbar/images/system-reboot.svg".source = ./files/system-reboot.svg;
      ".config/nwg-launchers/nwgbar/images/system-log-out.svg".source = ./files/system-log-out.svg;
      ".config/nwg-launchers/nwgbar/images/system-suspend.svg".source = ./files/system-suspend.svg;
      ".config/nwg-launchers/nwgbar/images/system-shutdown.svg".source = ./files/system-shutdown.svg;
      ".config/nwg-launchers/nwgbar/images/system-hibernate.svg".source = ./files/system-hibernate.svg;
      ".config/nwg-launchers/nwgbar/images/system-lock-screen.svg".source = ./files/system-lock-screen.svg;
      ".config/nwg-launchers/nwgbar/bar.json".text = ''
[
  {
    "name": "Lock",
    "exec": "/home/${username}/.config/sway/lock.sh",
    "icon": "/home/${username}/.config/nwg-launchers/nwgbar/images/system-lock-screen.svg"
  },
  {
    "name": "Logout",
    "exec": "swaymsg exit",
    "icon": "/home/${username}/.config/nwg-launchers/nwgbar/images/system-log-out.svg"
  },
  {
    "name": "Reboot",
    "exec": "systemctl reboot",
    "icon": "/home/${username}/.config/nwg-launchers/nwgbar/images/system-reboot.svg"
  },
  {
    "name": "Shutdown",
    "exec": "systemctl -i poweroff",
    "icon": "/home/${username}/.config/nwg-launchers/nwgbar/images/system-shutdown.svg"
  }
]
      '';
      ".config/nwg-launchers/nwgbar/style.css".text = ''
* {
    color: ${colorScheme.foreground};
}

button, label, image {
    background: none;
    border-style: none;
    box-shadow: none;
    color: #999;
}

button {
    padding: 5px;
    margin: 5px;
    text-shadow: none;
}

button:hover {
    background-color: rgba (255, 255, 255, 0.1);
}

button:focus {
    box-shadow: 0 0 10px;
}

button:checked {
    background-color: rgba (255, 255, 255, 0.1);
}

#searchbox {
    background: none;
    border-color: #999;
    color: #ccc;
    margin-top: 20px;
    margin-bottom: 20px
}

#separator {
    background-color: rgba(200, 200, 200, 0.5);
    margin-left: 500px;
    margin-right: 500px;
    margin-top: 10px;
    margin-bottom: 10px
}

#description {
    margin-bottom: 20px
}
      '';
      ".config/nwg-launchers/nwggrid/style.css".text = ''
* {
    color: ${colorScheme.foreground};
}

button, label, image {
    background: none;
    border-style: none;
    box-shadow: none;
    color: #999;
}

button {
    padding: 5px;
    margin: 5px;
    text-shadow: none;
}

button:hover {
    background-color: rgba (255, 255, 255, 0.1);
}

button:focus {
    box-shadow: 0 0 10px;
}

button:checked {
    background-color: rgba (255, 255, 255, 0.1);
}

#searchbox {
    background: none;
    border-color: #999;
    color: #ccc;
    margin-top: 20px;
    margin-bottom: 20px
}

#separator {
    background-color: rgba(200, 200, 200, 0.5);
    margin-left: 500px;
    margin-right: 500px;
    margin-top: 10px;
    margin-bottom: 10px
}

#description {
    margin-bottom: 20px
}
      '';
      ".config/swaync/style.css".text = ''
* {
  all: unset;
  font-size: 14px;
  font-family: "Ubuntu Nerd Font";
  transition: 200ms;
}

.floating-notifications.background .notification-row .notification-background {
  box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px ${colorScheme.background_bright};
  border-radius: 12.6px;
  margin: 18px;
  background-color: ${colorScheme.background};
  color: ${colorScheme.foreground};
  padding: 0;
}

.floating-notifications.background .notification-row .notification-background .notification {
  padding: 7px;
  border-radius: 12.6px;
}

.floating-notifications.background .notification-row .notification-background .notification.critical {
  box-shadow: inset 0 0 7px 0 ${colorScheme.red};
}

.floating-notifications.background .notification-row .notification-background .notification .notification-content {
  margin: 7px;
}

.floating-notifications.background .notification-row .notification-background .notification .notification-content .summary {
  color: ${colorScheme.foreground};
}

.floating-notifications.background .notification-row .notification-background .notification .notification-content .time {
  color: ${colorScheme.whiteBright};
}

.floating-notifications.background .notification-row .notification-background .notification .notification-content .body {
  color: ${colorScheme.foreground};
}

.floating-notifications.background .notification-row .notification-background .notification > *:last-child > * {
  min-height: 3.4em;
}

.floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action {
  border-radius: 7px;
  color: ${colorScheme.foreground};
  background-color: ${colorScheme.background_bright};
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
  margin: 7px;
}

.floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
  background-color: ${colorScheme.background_bright};
  color: ${colorScheme.foreground};
}

.floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
  background-color: ${colorScheme.mark3_background};
  color: ${colorScheme.foreground};
}

.floating-notifications.background .notification-row .notification-background .close-button {
  margin: 7px;
  padding: 2px;
  border-radius: 6.3px;
  color: ${colorScheme.background};
  background-color: ${colorScheme.red};
}

.floating-notifications.background .notification-row .notification-background .close-button:hover {
  background-color: #eba0ac;
  color: ${colorScheme.background};
}

.floating-notifications.background .notification-row .notification-background .close-button:active {
  background-color: ${colorScheme.red};
  color: ${colorScheme.background};
}

.control-center {
  box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px ${colorScheme.background_bright};
  border-radius: 12.6px;
  margin: 18px;
  background-color: ${colorScheme.background};
  color: ${colorScheme.foreground};
  padding: 14px;
}

.control-center .widget-title {
  color: ${colorScheme.foreground};
  font-size: 1.3em;
}

.control-center .widget-title button {
  border-radius: 7px;
  color: ${colorScheme.foreground};
  background-color: ${colorScheme.background_bright};
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
  padding: 8px;
}

.control-center .widget-title button:hover {
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
  background-color: #585b70;
  color: ${colorScheme.foreground};
}

.control-center .widget-title button:active {
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
  background-color: ${colorScheme.mark3_background};
  color: ${colorScheme.background};
}

.control-center .notification-row .notification-background {
  border-radius: 7px;
  color: ${colorScheme.foreground};
  background-color: ${colorScheme.background_bright};
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
  margin-top: 14px;
}

.control-center .notification-row .notification-background .notification {
  padding: 7px;
  border-radius: 7px;
}

.control-center .notification-row .notification-background .notification.critical {
  box-shadow: inset 0 0 7px 0 ${colorScheme.red};
}

.control-center .notification-row .notification-background .notification .notification-content {
  margin: 7px;
}

.control-center .notification-row .notification-background .notification .notification-content .summary {
  color: ${colorScheme.foreground};
}

.control-center .notification-row .notification-background .notification .notification-content .time {
  color: ${colorScheme.whiteBright};
}

.control-center .notification-row .notification-background .notification .notification-content .body {
  color: ${colorScheme.foreground};
}

.control-center .notification-row .notification-background .notification > *:last-child > * {
  min-height: 3.4em;
}

.control-center .notification-row .notification-background .notification > *:last-child > * .notification-action {
  border-radius: 7px;
  color: ${colorScheme.foreground};
  background-color: ${colorScheme.tab_bar_background};
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
  margin: 7px;
}

.control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
  background-color: ${colorScheme.background_bright};
  color: ${colorScheme.foreground};
}

.control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
  background-color: ${colorScheme.mark3_background};
  color: ${colorScheme.foreground};
}

.control-center .notification-row .notification-background .close-button {
  margin: 7px;
  padding: 2px;
  border-radius: 6.3px;
  color: ${colorScheme.background};
  background-color: #eba0ac;
}

.control-center .notification-row .notification-background .close-button:hover {
  background-color: ${colorScheme.red};
  color: ${colorScheme.background};
}

.control-center .notification-row .notification-background .close-button:active {
  background-color: ${colorScheme.red};
  color: ${colorScheme.background};
}

.control-center .notification-row .notification-background:hover {
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
  background-color: #7f849c;
  color: ${colorScheme.foreground};
}

.control-center .notification-row .notification-background:active {
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
  background-color: ${colorScheme.mark3_background};
  color: ${colorScheme.foreground};
}

progressbar,
progress,
trough {
  border-radius: 12.6px;
}

progressbar {
  box-shadow: inset 0 0 0 1px ${colorScheme.black};
}

.notification.critical progress {
  background-color: ${colorScheme.red};
}

.notification.low progress,
.notification.normal progress {
  background-color: ${colorScheme.blue};
}

trough {
  background-color: ${colorScheme.background_bright};
}

.control-center trough {
  background-color: ${colorScheme.black};
}

.control-center-dnd {
  margin-top: 5px;
  border-radius: 8px;
  background: ${colorScheme.background_bright};
  border: 1px solid ${colorScheme.black};
  box-shadow: none;
}

.control-center-dnd:checked {
  background: ${colorScheme.background_bright};
}

.control-center-dnd slider {
  background: ${colorScheme.black};
  border-radius: 8px;
}

.widget-dnd {
  margin: 0px;
  font-size: 1.1rem;
}

.widget-dnd > switch {
  font-size: initial;
  border-radius: 8px;
  background: ${colorScheme.background_bright};
  border: 1px solid ${colorScheme.black};
  box-shadow: none;
}

.widget-dnd > switch:checked {
  background: ${colorScheme.background_bright};
}

.widget-dnd > switch slider {
  background: ${colorScheme.black};
  border-radius: 8px;
  border: 1px solid ${colorScheme.inactive_border_color};
}
      '';
    };
  };
  wayland.windowManager.sway = {
    enable = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
    wrapperFeatures.gtk = true;
    # extraSessionCommands = ''
    #   export _JAVA_AWT_WM_NONREPARENTING=1
    #   export GTK_THEME='Catppuccin-Mocha-Compact-Blue-Dark:dark'
    #   export QT_AUTO_SCREEN_SCALE_FACTOR=1
    #   export QT_QPA_PLATFORM=wayland
    #   export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    #   export GDK_BACKEND=wayland
    #   export XDG_CURRENT_DESKTOP=sway
    #   export WLR_RENDERER=vulkan
    #   export WLR_NO_HARDWARE_CURSORS=1
    #   export XWAYALND_NO_GLAMOR=1
    # '';
    config = {
      gaps = {
        smartBorders = "on";
        smartGaps = true;
      };
      floating.border = 1;
      window.border = 1;
      bars = [{ command = "waybar"; }];
      colors = {
        focused = {
          background = colorScheme.green;
          border = colorScheme.greenBright;
          childBorder = colorScheme.green;
          indicator = colorScheme.green;
          text = colorScheme.black;
        };
        focusedInactive = {
          background = colorScheme.yellow;
          border = colorScheme.yellowBright;
          childBorder = colorScheme.yellow;
          indicator = colorScheme.yellow;
          text = colorScheme.black;
        };
        unfocused = {
          background = colorScheme.blue;
          border = colorScheme.blueBright;
          childBorder = colorScheme.blue;
          indicator = colorScheme.blue;
          text = colorScheme.black;
        };
        urgent = {
          background = colorScheme.red;
          border = colorScheme.redBright;
          childBorder = colorScheme.red;
          indicator = colorScheme.red;
          text = colorScheme.black;
        };
        background = colorScheme.black;
      };
      fonts = {
        names = [ "Roboto" ];
        style = "Regular Bold";
        size = 12.0;
      };
      input = {
        "type:keyboard" = {
          xkb_layout = lib.mkDefault "us";
          xkb_variant = lib.mkDefault "altgr-intl";
        };
      };
      menu = menu;
      modifier = modifier;
      left = left;
      down = down;
      up = up;
      right = right;
      keybindings = {
        # Exit sway (logs you out of your Wayland session)
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        # Reload the configuration file
        "${modifier}+Shift+c" = "reload";
        # Kill focused window
        "${modifier}+Shift+q" = "kill";
        "${modifier}+a" = "exec sh .config/sway/lock.sh";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+Escape" = "exec ${menu}";
        # Launch the default terminal. $TERM is defined in ../alacritty.nix line 11
        "${modifier}+Return" = "exec kitty";
        # Take a screenshot by selecting an area
        "print" = "exec sh $HOME/.config/sway/screenshot.sh active";
        "Shift+print" = "exec sh $HOME/.config/sway/screenshot.sh output";
        "${modifier}+print" = "exec sh $HOME/.config/sway/screenshot.sh screen";
        "${modifier}+n" = "exec ${filebrowser}";
        "${modifier}+Shift+g" = "exec ${webbrowser}";
        "${modifier}+g" = "exec ${webbrowserPersistent}";
        "${modifier}+m" = "exec ${musicplayer}";
        # Toggle deafen
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        # Toggle mute
        "XF86AudioMute+Ctrl" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle && ffmpeg -y -f lavfi -i 'sine=frequency=200:duration=0.1' /tmp/sound.ogg && play /tmp/sound.ogg";
        # Raise sink (speaker, headphones) volume
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +2%";
        # Lower sink (microphone) volume
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -2%";
        # Spotify
        ## Play/pause spotify
        "XF86AudioPlay" = "exec dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause";
        ## Play previous spotify track
        "XF86AudioPrev" = "exec dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous";
        "XF86Launch5" = "exec dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous";
        ## Play next spotify track
        "XF86AudioNext" = "exec dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next";
        "XF86Tools" = "exec dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next";

        # Moving around
        ## Move your focus around
        "${modifier}+${left}" = "focus left";
        "${modifier}+${down}" = "focus down";
        "${modifier}+${up}" = "focus up";
        "${modifier}+${right}" = "focus right";
        ## Move the focused window with the same, but add Shift
        "${modifier}+Shift+${left}" = "move left";
        "${modifier}+Shift+${down}" = "move down";
        "${modifier}+Shift+${up}" = "move up";
        "${modifier}+Shift+${right}" = "move right";
        # Workspaces
        ## Switch to workspace
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";
        ## Move focused container to workspace
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";
        ## Workspaces can have any name you want, not just numbers.
        ## We just use 1-10 as the default.
        # Layout stuff
        ## You can "split" the current object of your focus with ${modifier}+b, ${modifier}+v for horizontal and vertical splits respectively.
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";
        ## Switch the current container between different layout styles
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        ## Make the current focus fullscreen
        "${modifier}+f" = "fullscreen";
        ## Toggle the current focus between tiling and floating mode
        "${modifier}+Shift+space" = "floating toggle";
        ## Swap focus between the tiling area and the floating area
        "${modifier}+space" = "focus mode_toggle";
        ## Move focus to the parent container
        "${modifier}+p" = "focus parent";
        # Scratchpad
        ## Sway has a "scratchpad", which is a bag of holding for windows. You can send windows there and get them back later.
        ## Move the currently focused window to the scratchpad
        "${modifier}+Shift+minus" = "move scratchpad";
        ## Show the next scratchpad window or hide the focused scratchpad window. If there are multiple scratchpad windows, this command cycles through them.
        "${modifier}+minus" = "scratchpad show";
        # Resizing containers
        # Mode "resize"
        "${modifier}+r" = "mode 'resize'";
        # Mode "resize"
        "${modifier}+x" = "exec nwgbar -b '${colorScheme.background}'";
      };
      modes = {
        rezise = {
          # left will shrink the containers width
          # right will grow the containers width
          # up will shrink the containers height
          # down will grow the containers height
          "${modifier}+${left}" = "resize shrink width ${resizeAmount}";
          "${modifier}+${down}" = "resize grow height ${resizeAmount}";
          "${modifier}+${up}" = "resize shrink height ${resizeAmount}";
          "${modifier}+${right}" = "resize grow width ${resizeAmount}";
          # Return to default mode
          "Return" = "mode 'default'";
          "Escape" = "mode 'default'";
        };
      };
      startup = [
        # Note taking app
        { command = "obsidian"; }
        # Notification daemon
        { command = "swaync"; }
        # Spotify
        { command = "spotify"; }
        # Web browsing
        { command = "NIXOS_OZONE_WL=1 google-chrome-stable"; }
        # Chatting
        { command = "telegram-desktop"; }
        # Polkit
        { command = "/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1"; }
        # Idle
        { command = "$HOME/.config/sway/idle.sh"; }
      ];
      terminal = pkgs.kitty;
      window.titlebar = false;
      workspaceAutoBackAndForth = true;
      output = {
        "*" = { bg = "${background} fill ${colorScheme.background}"; };
      };
    };
    extraConfig = ''
      for_window [urgent="latest"] focus
      focus_on_window_activation   focus
      focus_follows_mouse yes

      for_window [app_id="(?i)(?:blueman-manager|azote|gnome-disks|opensnitch_ui)"] floating enable
      for_window [app_id="(?i)(?:pavucontrol|nm-connection-editor|gsimplecal|galculator)"] floating enable
      for_window [app_id="(?i)(?:firefox|chromium)"] border none
      for_window [title="(?i)(?:copying|deleting|moving)"] floating enable

      popup_during_fullscreen smart
    '';
  };
  home.packages = with pkgs; [
    tesseract4
    foot
    waybar
    (obsidian.override {
      electron = electron;
    }) # electron app
    networkmanagerapplet
    dmenu-wayland
    ulauncher
    nwg-launchers
    telegram-desktop
    wofi
    wofi-emoji
    slurp
    ydiff
    grim
    swappy
    swaylock-effects
    notify-desktop
    libappindicator
    gnome.zenity
    spotify
    wl-clipboard
    cinnamon.nemo
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = { package = pkgs.gnome3.adwaita-icon-theme; name = "adwaita"; };
  };
}
