{ inputs, ... }: {
  services."www".service = {
    image = "registry.n0de.biz/daniel/derzer:master";
    restart = "unless-stopped";
    container_name = "www";
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.www.rule" = "HostRegexp(`{subdomain:.*}.n0de.biz`, `n0de.biz`, `www.n0de.biz`)";
      "traefik.http.routers.www.priority" = "1";
      "traefik.http.services.www.loadbalancer.server.port" = "8080";
      "traefik.http.routers.www.entrypoints" = "websecure";
      "traefik.http.routers.www.tls.certresolver" = "myresolver";
      "traefik.http.routers.www.tls.domains[0].main" = "n0de.biz";
      "traefik.http.routers.www.tls.domains[0].sans" = "*.n0de.biz";
    };
  };
}
