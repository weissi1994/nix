{ inputs, config, ... }: {
  virtualisation.oci-containers.containers = {
    crafty = {
      image = "registry.gitlab.com/crafty-controller/crafty-4:latest";
      hostname = "minecraft";
      ports = [
        "4443:8443"
        "4123:8123"
        "25500-25600:25500-25600"
      ];
      volumes = [
        "/srv/minecraft/backups:/crafty/backups"
        "/srv/minecraft/logs:/crafty/logs"
        "/srv/minecraft/servers:/crafty/servers"
        "/srv/minecraft/config:/crafty/app/config"
        "/srv/minecraft/import:/crafty/import"
      ];
    };
  };
}
