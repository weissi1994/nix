{ inputs, config, ... }: {
  sops.secrets.mail_env = { };
  virtualisation.oci-containers.containers = {
    mail = {
      image = "bytemark/smtp";
      hostname = "mail.n0de.biz";
      ports = [ "25:25" ];
      environmentFiles = [ config.sops.secrets.mail_env.path ];
    };
  };
}
