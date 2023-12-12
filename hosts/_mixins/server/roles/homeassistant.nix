{ inputs, config, ... }: {
  virtualisation.oci-containers.containers = {
    homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      hostname = "homeassistant";
      extraOptions = [ "--privileged" "--network=host" ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.homeassistant.rule" = "Host(`homeassistant.n0de.biz`)";
        "traefik.http.routers.homeassistant.priority" = "2";
        "traefik.http.services.homeassistant.loadbalancer.server.port" = "8123";
        "traefik.http.routers.homeassistant.entrypoints" = "websecure";
        "traefik.http.routers.homeassistant.tls.certresolver" = "myresolver";
      };
      volumes = [
        "/srv/homeassistant:/config"
      ];
    };
  };
}
