{ inputs, pkgs, config, ... }: {

  sops.secrets.immich_env = with config.virtualisation.oci-containers; { 
    restartUnits = [ "${backend}-immich-server.service" "${backend}-immich-machine-learning.service" "${backend}-immich-microservices.service" "${backend}-typesense.service" "${backend}-redis.service" "${backend}-database.service" ];
  };

  systemd.services.create-immich-pod = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "${backend}-immich-server.service" "${backend}-immich-machine-learning.service" "${backend}-immich-microservices.service" "${backend}-typesense.service" "${backend}-redis.service" "${backend}-database.service" ];
    script = ''
      ${pkgs.podman}/bin/podman pod exists immich || \
        ${pkgs.podman}/bin/podman pod create -n immich
    '';
  };

  virtualisation.oci-containers.containers = {
    immich-server = {
      image = "ghcr.io/immich-app/immich-server:release";
      extraOptions = [ "--pod=immich" ];
      cmd = [
        "start.sh"
        "immich"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.immich.rule" = "Host(`img.n0de.biz`)";
        "traefik.http.routers.immich.priority" = "2";
        "traefik.http.services.immich.loadbalancer.server.port" = "3001";
        "traefik.http.routers.immich.entrypoints" = "websecure";
        "traefik.http.routers.immich.tls.certresolver" = "myresolver";
      };
      environmentFiles = [ config.sops.secrets.immich_env.path ];
      dependsOn = [
        "redis"
        "database"
        "typesense"
      ];
      volumes = [
        "/srv/immich/data/library:/usr/src/app/upload"
      ];
    };
    immich-machine-learning = {
      image = "ghcr.io/immich-app/immich-machine-learning:release";
      extraOptions = [ "--pod=immich" ];
      environmentFiles = [ config.sops.secrets.immich_env.path ];
      volumes = [
        "/srv/immich/data/library:/usr/src/app/upload"
        "/srv/immich/data/cache:/cache"
      ];
    };
    immich-microservices = {
      image = "ghcr.io/immich-app/immich-server:release";
      extraOptions = [ "--pod=immich" ];
      cmd = [
        "start.sh"
        "microservices"
      ];
      environmentFiles = [ config.sops.secrets.immich_env.path ];
      dependsOn = [
        "database"
        "immich-server"
        "typesense"
      ];
      volumes = [
        "/srv/immich/data/library:/usr/src/app/upload"
      ];
    };
    typesense = {
      image = "typesense/typesense:0.24.1@sha256:9bcff2b829f12074426ca044b56160ca9d777a0c488303469143dd9f8259d4dd";
      extraOptions = [ "--pod=immich" ];
      environmentFiles = [ config.sops.secrets.immich_env.path ];
      volumes = [
        "/srv/immich/data/typesense:/data"
      ];
    };
    redis = {
      image = "redis:6.2-alpine@sha256:70a7a5b641117670beae0d80658430853896b5ef269ccf00d1827427e3263fa3";
      extraOptions = [ "--pod=immich" ];
    };
    database = {
      image = "postgres:14-alpine@sha256:28407a9961e76f2d285dc6991e8e48893503cc3836a4755bbc2d40bcc272a441";
      extraOptions = [ "--pod=immich" ];
      environmentFiles = [ config.sops.secrets.immich_env.path ];
      volumes = [
        "/srv/immich/data/db:/var/lib/postgresql/data"
      ];
    };
  };
}
