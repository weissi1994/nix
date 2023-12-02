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
    wezterm

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
      "lxd"
      "podman"
    ];
    # mkpasswd -m sha-512
    # initialHashedPassword = "If you want a backup password set one here, generated with the command above";
    hashedPassword = null; # You can also set one here, but you should use sosps or similar when doing so
    homeMode = "0755";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDc4BKHvvS9dAiVOAEH5jD1vbVE9Ceb1xArQ6wrW19e0bhIbaZ4K5mC8SLMNhSbN85LwcsE6rhwFuT9wwVLWO7Htcrzo0ymTnG6aIrPg7BVQNgHhRAAgxvCgBcQ5QxzCcPcJAExxy4rA+yDrrqpHE6is3FTgz7/HSUHHJE5zqGKxdTdlg+33LHoqDWH0w3ftFzC2PguVPH02a9Fq4MkbYCyA/aO9FLXR03y6qK8HuEQFnHddQqhNs/2PjbPb7kYY5AZyGpqIFMYsFlO1JaqZh/nXUNcS/oM63Cl7nuInwU/4Jx9zGSrH9FqTeClqeyJLS5hn/kNGeQZDHOCzeowOzVvsCApkoQJXS2WBzD7fmCRjJ110sPrgIiB+D+3pESmsU808rSa4QEwEBnVGJEq4UmyV5Ev8oSZpXgVFCpxmHq/78fbFAAcX3JhbejQWdaMahcm4OWkuGkdT3zhxgMomO28f1dUUIXsfx9NwJ14Du8afJIz+gDs3r6Ktb5Q8g6PDSzZ8mMgwKvP7rydHgjOe4yAR8N3KpqFLnokxCEOcvNuQiv3LhQ0agFuFcWMmHP+GmVgpJQRqv1rueufONFaKsaPSn9q0Od6CjmEVE8FRwsrreB479gbe5HNhGeFjMdRjLksFER3nF8XgTOhdzVs/Bixn4P7ZoseNbcJymSqJW8sxQ== cardno:13 338 635"
    ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.fish;
  };
}
