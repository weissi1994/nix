{ pkgs, username, lib, ... }:
{
  programs.ssh.startAgent = false;
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.u2f.enable = true;
  security.pam.u2f.cue = true;

  security.pam.services = {
    login.u2fAuth = true;
    gdm-password.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  # security.auditd.enable = true;
  # security.audit.enable = lib.mkDefault true;
  # security.audit.rules = [
  #   "-a exit,always -F arch=b64 -S execve"
  # ];

  security.sudo = {
    enable = true;
    execWheelOnly = true;
    extraRules = [{
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }];
  };

  environment.systemPackages = with pkgs; [
    gnupg
    libfido2
    libu2f-host
    yubikey-personalization
    vulnix
  ];

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  services.udev.packages = with pkgs; [
    libu2f-host
    yubikey-personalization
  ];

  # Auth already done during decryption
  services.xserver.displayManager.autoLogin.user = "${username}";
  # Works around https://github.com/NixOS/nixpkgs/issues/103746
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}

