{ outputs, lib, config, ... }:
{
  services.openssh = {
    enable = true;
    allowSFTP = false;

    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = lib.mkDefault "no";
      ChallengeResponseAuthentication = false;
      AllowTcpForwarding = "yes";
      X11Forwarding = false;
      AllowAgentForwarding = "no";
      AllowStreamLocalForwarding = "no";
      AuthenticationMethods = "publickey";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
    };

    hostKeys = [{
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };
}
