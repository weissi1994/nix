{ inputs, roles, ... }: {
  virtualisation.arion = {
    backend = "podman-socket";
    projects = {
      "n0de".settings = {
        services = {
          "traefik".service = {
            image = "traefik:latest";
            restart = "unless-stopped";
            container_name = "traefik";
            ports = [ "80:80" "443:443" "8080:8080" ];
            env_file = [ "/run/secrets/docker/traefik" ];
            volumes = [
              "/srv/traefik/letsencrypt:/letsencrypt"
              "/srv/traefik/conf:/etc/traefik/conf"
              "/var/log/traefik:/var/log/traefik"
              "/var/run/docker.sock:/var/run/docker.sock:ro"
            ];
          };
        };
        imports = roles;
      };
    };
  };
}
