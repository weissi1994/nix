{ config, desktop, lib, pkgs, ... }:
let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  imports = [ ]
  ++ lib.optionals (desktop != null) [
    ../../desktop/${desktop}.nix
    ../../desktop/apps/${desktop}.nix
    ../../desktop/programs/chromium.nix
    ../../desktop/programs/chromium-extensions.nix
  ];

  environment.systemPackages = with pkgs; [
    htop
    gping
    httpie
  ] ++ lib.optionals (desktop != null) [
    gimp-with-plugins
    foot # as fallback terminal
    libreoffice
    pick-colour-picker
    wmctrl
    xdotool
    ydotool
    kitty

    # Fast moving apps use the unstable branch
    unstable.google-chrome
    unstable.tdesktop
  ];

  users.users.dweissengruber = {
    description = "dweissengruber";
    extraGroups = [
      "audio"
      "input"
      "networkmanager"
      "users"
      "video"
      "wheel"
    ]
    ++ ifExists [
      "docker"
      "podman"
    ];
    # mkpasswd -m sha-512
    # initialHashedPassword = "If you want a backup password set one here, generated with the command above";
    hashedPassword = null; # You can also set one here, but you should use sosps or similar when doing so
    homeMode = "0755";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxKqWCZM2Kua99LNKQv+Tf+EI3pDV+dJD/IkcKaayG4NfDn7FhapJisFP0KI/9R5jtc4IdJWtuY4VhhwJMuhQ4+WXG4G/E7O1eL3O7l/mGd1WgjUp6Nf0rmZFwTSpZ4OOFxx2EwfetUVo4e4Sph+m8Dqs/hK/BvUuHjvy5i8b8XZ+09L2LGLx33EZl30BfAyfjURgywQrHz+60iVYfAh9kQyTaJIjHWkC56pDslAOFmKAUudNV9FPKIjVgP3RI+JVpBWKee6/cdlWIx9sNNpxN53WT/SaRZLUWmw7l+xCXkwE2Q1jyjRWWB6NOocqCVLOiRIOtRtAzIC5CHh2iSVDv cardno:9240467"
    ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.fish;
  };
}
