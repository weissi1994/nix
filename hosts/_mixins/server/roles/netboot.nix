{ inputs, config, ... }: {
  virtualisation.oci-containers.containers = {
    netboot = {
      image = "ghcr.io/netbootxyz/netbootxyz";
      hostname = "boot.n0de.biz";
      ports = [ "69:69/udp" ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.boot-admin.rule" = "Host(`boot-admin.n0de.biz`)";
        "traefik.http.routers.boot-admin.priority" = "2";
        "traefik.http.services.boot-admin.loadbalancer.server.port" = "3000";
        "traefik.http.routers.boot-admin.entrypoints" = "websecure";
        "traefik.http.routers.boot-admin.tls.certresolver" = "myresolver";
        "traefik.http.routers.boot-admin.service" = "boot-admin";
        "traefik.http.routers.boot.rule" = "Host(`boot.n0de.biz`)";
        "traefik.http.routers.boot.priority" = "2";
        "traefik.http.services.boot.loadbalancer.server.port" = "80";
        "traefik.http.routers.boot.entrypoints" = "websecure";
        "traefik.http.routers.boot.tls.certresolver" = "myresolver";
        "traefik.http.routers.boot.service" = "boot";
      };
      environment = {
        "PUID" = "1000";
        "PGID" = "1000";
        "TZ" = "Etc/UTC";
      };
      volumes = [
        "/srv/netboot/config:/config"
        "/srv/netboot/assets:/assets"
      ];
    };
  };
}
