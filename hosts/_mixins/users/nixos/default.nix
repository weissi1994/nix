{ self, config, desktop, offline_installer, lib, pkgs, username, ... }:
let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  isNotInstaller = n: n != "installer";
  candidates = builtins.filter isNotInstaller config.nixosConfigurations;

  # disko
  disko = if (offline_installer != null) then
    pkgs.writeShellScriptBin "disko" ''${self.nixosConfigurations.${offline_installer}.config.system.build.diskoScript}''
  else
    pkgs.writeShellScriptBin "disko" "true";
  disko-mount = if (offline_installer != null) then
    pkgs.writeShellScriptBin "disko-mount" "${self.nixosConfigurations.${offline_installer}.config.system.build.mountScript}"
  else
    pkgs.writeShellScriptBin "disko-mount" "true";
  disko-format = if (offline_installer != null) then
    pkgs.writeShellScriptBin "disko-format" "${self.nixosConfigurations.${offline_installer}.config.system.build.formatScript}"
  else
    pkgs.writeShellScriptBin "disko-format" "true";
  # system
  system = if (offline_installer != null) then
    self.nixosConfigurations.${offline_installer}.config.system.build.toplevel
  else
    pkgs.writeShellScriptBin "dummy-system" "true";

  install-system-offline = pkgs.writeShellScriptBin "install-system-offline" ''
    set -euo pipefail

    echo "Formatting disks..."
    . ${disko-format}/bin/disko-format

    echo "Mounting disks..."
    . ${disko-mount}/bin/disko-mount

    echo "Installing system..."
    nixos-install --no-root-password --system ${system}

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      lsblk -o NAME,MODEL,SIZE,SERIAL,VENDOR,WWN
      read -p "Specify disk to format (absolute path; preferable using WWN): " TARGET_DISK
      systemd-cryptenroll --fido2-device=auto "$TARGET_DISK-part2"
    fi

    echo "Done!"
  '';

  install-system = pkgs.writeScriptBin "install-system" ''
#!${pkgs.stdenv.shell}

# set -euo pipefail

TARGET_HOST="''${1:-}"
TARGET_USER="''${2:-ion}"

if [ "$(id -u)" -eq 0 ]; then
  echo "ERROR! $(basename "$0") should be run as a regular user"
  exit 1
fi

if [ ! -d "$HOME/dev/nix" ]; then
  mkdir -p $HOME/dev
  cp -r ${self.sourceInfo.outPath} "$HOME/dev/nix"
fi

pushd "$HOME/dev/nix"

if [[ -z "$TARGET_HOST" ]]; then
  echo "ERROR! $(basename "$0") requires a hostname as the first argument"
  echo "       The following hosts are available"
  ls -1 hosts/*/default.nix | cut -d'/' -f2 | grep -v iso
  exit 1
fi

if [[ -z "$TARGET_USER" ]]; then
  echo "ERROR! $(basename "$0") requires a username as the second argument"
  echo "       The following users are available"
  ls -1 hosts/_mixins/users/ | grep -v -E "nixos|root"
  exit 1
fi

echo "WARNING! The disks in $TARGET_HOST are about to get wiped"
echo "         NixOS will be re-installed"
echo "         This is a destructive operation"
echo
read -p "Are you sure? [y/N]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo true
  TARGET_DISK=$(cat "hosts/$TARGET_HOST/default.nix" | grep -oP '    disks = \["\K[/a-zA-Z0-9-.]+' | grep -v 'CHANGE')

  if [[ -z "$TARGET_DISK" ]]; then
    sudo lsblk -o NAME,MODEL,SIZE,SERIAL,VENDOR,WWN
    read -p "Specify disk to format (absolute path; preferable using WWN): " TARGET_DISK
    sudo sed -i "s/CHANGE_ME/$TARGET_DISK/" "hosts/$TARGET_HOST/default.nix"
    sudo nix run github:nix-community/disko -- --mode zap_create_mount --flake .#generic
  else
    sudo nix build .#nixosConfigurations.$TARGET_HOST.config.system.build.diskoScript
    sudo ./result
  fi

  # TODO: if os_layout == btrfs
  btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

  sudo nixos-install --no-root-password --flake ".#$TARGET_HOST"

  echo "Disk $TARGET_DISK formatted."
  echo "Installation completed."
  echo
  echo "Do you want to add fido2 encryption to luks?"
  read -p "If so plug in your yubikey! [y/N]" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo systemd-cryptenroll --fido2-device=auto "$TARGET_DISK-part2"
  fi
fi
'';
in
{
  # Only include desktop components if one is supplied.
  imports = [ ] ++ lib.optional (desktop != null) ./desktop.nix;

  config.users.users.nixos = {
    description = "NixOS";
    extraGroups = [
      "audio"
      "networkmanager"
      "users"
      "video"
      "wheel"
    ]
    ++ ifExists [
      "docker"
      "podman"
    ];
    homeMode = "0755";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDc4BKHvvS9dAiVOAEH5jD1vbVE9Ceb1xArQ6wrW19e0bhIbaZ4K5mC8SLMNhSbN85LwcsE6rhwFuT9wwVLWO7Htcrzo0ymTnG6aIrPg7BVQNgHhRAAgxvCgBcQ5QxzCcPcJAExxy4rA+yDrrqpHE6is3FTgz7/HSUHHJE5zqGKxdTdlg+33LHoqDWH0w3ftFzC2PguVPH02a9Fq4MkbYCyA/aO9FLXR03y6qK8HuEQFnHddQqhNs/2PjbPb7kYY5AZyGpqIFMYsFlO1JaqZh/nXUNcS/oM63Cl7nuInwU/4Jx9zGSrH9FqTeClqeyJLS5hn/kNGeQZDHOCzeowOzVvsCApkoQJXS2WBzD7fmCRjJ110sPrgIiB+D+3pESmsU808rSa4QEwEBnVGJEq4UmyV5Ev8oSZpXgVFCpxmHq/78fbFAAcX3JhbejQWdaMahcm4OWkuGkdT3zhxgMomO28f1dUUIXsfx9NwJ14Du8afJIz+gDs3r6Ktb5Q8g6PDSzZ8mMgwKvP7rydHgjOe4yAR8N3KpqFLnokxCEOcvNuQiv3LhQ0agFuFcWMmHP+GmVgpJQRqv1rueufONFaKsaPSn9q0Od6CjmEVE8FRwsrreB479gbe5HNhGeFjMdRjLksFER3nF8XgTOhdzVs/Bixn4P7ZoseNbcJymSqJW8sxQ== cardno:13 338 635"
    ];
    packages = [
      pkgs.home-manager
    ];
    shell = pkgs.fish;
  };

  config.system.stateVersion = lib.mkForce lib.trivial.release;
  config.environment.systemPackages = [
    install-system
  ] ++ (if (offline_installer != null) then [
    disko
    disko-mount
    disko-format
    install-system-offline
  ] else []);
  config.services.kmscon.autologinUser = "${username}";
}
