{ inputs, config, ... }: {
  virtualisation.oci-containers.containers = {
    kuma = {
      image = "louislam/uptime-kuma:1";
      hostname = "kuma";
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.kuma.rule" = "Host(`status.n0de.biz`)";
        "traefik.http.routers.kuma.priority" = "2";
        "traefik.http.services.kuma.loadbalancer.server.port" = "3001";
        "traefik.http.routers.kuma.entrypoints" = "websecure";
        "traefik.http.routers.kuma.tls.certresolver" = "myresolver";
      };
      volumes = [
        "/srv/kuma/data:/app/data"
      ];
    };
  };
}
