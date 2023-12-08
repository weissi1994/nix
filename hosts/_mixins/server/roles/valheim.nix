{ inputs, config, ... }: {
  sops.secrets.valheim_env = { };
  virtualisation.oci-containers.containers = {
    valheim = {
      image = "mbround18/valheim:latest";
      hostname = "valheim";
      environmentFiles = [ config.sops.secrets.valheim_env.path ];
      ports = [
        "2456:2456/udp"
        "2457:2457/udp"
        "2458:2458/udp"
      ];
      volumes = [
        "/srv/valheim/server:/home/steam/valheim"
        "/srv/valheim/saves:/home/steam/.config/unity3d/IronGate/Valheim"
        "/srv/valheim/backups:/home/steam/backups"
      ];
    };
  };
}
