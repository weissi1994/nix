{ inputs, config, ... }: {
  virtualisation.oci-containers.containers = {
    hoppscotch = {
      image = "hoppscotch/hoppscotch:latest";
      hostname = "hoppscotch";
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.hoppschotch.rule" = "Host(`api.n0de.biz`, `curl.n0de.biz`)";
        "traefik.http.routers.hoppschotch.priority" = "2";
        "traefik.http.services.hoppschotch.loadbalancer.server.port" = "3000";
        "traefik.http.routers.hoppschotch.entrypoints" = "websecure";
        "traefik.http.routers.hoppschotch.tls.certresolver" = "myresolver";
      };
    };
  };
}
