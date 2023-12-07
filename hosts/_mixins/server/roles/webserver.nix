{ inputs, ... }: {
  virtualisation.oci-containers.containers.www = {
    image = "registry.n0de.biz/daniel/derzer:master";
    login = {
      registry = "registry.n0de.biz";
      username = "deploy";
      passwordFile = "/run/secrets/docker/registry/n0de";
    };
    hostname = "www";
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