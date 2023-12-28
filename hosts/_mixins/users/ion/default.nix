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
    unstable.brave
    unstable.discord
    unstable.google-chrome
    unstable.tdesktop
  ];

  users.users.ion = {
    description = "Ion";
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
      (builtins.readFile ../../../../home/_mixins/users/ion/id_ed25519_sk.pub)
      (builtins.readFile ../../../../home/_mixins/users/ion/id_rsa_priv_yubikey.pub)
    ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.fish;
  };
}
