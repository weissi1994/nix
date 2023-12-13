{ inputs, config, ... }: {
  sops.secrets.n0de_registry_pass = { };
  virtualisation.oci-containers.containers = {
    www = {
      image = "registry.n0de.biz/daniel/derzer:master";
      login = {
        registry = "registry.n0de.biz";
        username = "daniel";
        passwordFile = config.sops.secrets.n0de_registry_pass.path;
      };
      hostname = "www";
      dependsOn = [
        "gitlab"
      ];
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
    meownster = {
      image = "registry.n0de.biz/meownster/website/master:latest";
      login = {
        registry = "registry.n0de.biz";
        username = "daniel";
        passwordFile = config.sops.secrets.n0de_registry_pass.path;
      };
      hostname = "meownster";
      dependsOn = [
        "gitlab"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.meownster.rule" = "HostRegexp(`{subdomain:.*}.meownster.com`, `meownster.com`, `www.meownster.com`)";
        "traefik.http.routers.meownster.priority" = "1";
        "traefik.http.services.meownster.loadbalancer.server.port" = "80";
        "traefik.http.routers.meownster.entrypoints" = "websecure";
        "traefik.http.routers.meownster.tls.certresolver" = "myresolver";
        "traefik.http.routers.meownster.tls.domains[0].main" = "meownster.com";
        "traefik.http.routers.meownster.tls.domains[0].sans" = "*.meownster.com";
      };
    };
    cv = {
      image = "registry.n0de.biz/daniel/cv:2721287506438dcae2c7f7406d503b78f5c4242e";
      login = {
        registry = "registry.n0de.biz";
        username = "daniel";
        passwordFile = config.sops.secrets.n0de_registry_pass.path;
      };
      hostname = "cv";
      dependsOn = [
        "gitlab"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.cv.rule" = "Host(`cv.n0de.biz`)";
        "traefik.http.routers.cv.priority" = "2";
        "traefik.http.services.cv.loadbalancer.server.port" = "8080";
        "traefik.http.routers.cv.entrypoints" = "websecure";
        "traefik.http.routers.cv.tls.certresolver" = "myresolver";
      };
    };
  };
}
