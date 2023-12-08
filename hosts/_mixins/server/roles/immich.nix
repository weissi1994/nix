{ inputs, config, ... }: {
  sops.secrets.immich_env = { };
  virtualisation.oci-containers.containers = {
    immich-server = {
      image = "ghcr.io/immich-app/immich-server:release";
      cmd = [
        "start.sh"
        "immich"
      ];
      hostname = "img.n0de.biz";
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.immich.rule" = "Host(`img.n0de.biz`)";
        "traefik.http.routers.immich.priority" = "2";
        "traefik.http.services.immich.loadbalancer.server.port" = "3001";
        "traefik.http.routers.immich.entrypoints" = "websecure";
        "traefik.http.routers.immich.tls.certresolver" = "myresolver";
      };
      environmentFiles = [ config.sops.secrets.immich_env.path ];
      volumes = [
        "/srv/immich/data/library:/usr/src/app/upload"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };
    immich-machine-learning = {
      image = "ghcr.io/immich-app/immich-machine-learning:release";
      hostname = "immich_machine_learning";
      environmentFiles = [ config.sops.secrets.immich_env.path ];
      volumes = [
        "/srv/immich/data/library:/usr/src/app/upload"
        "/srv/immich/data/cache:/cache"
      ];
    };
    immich-microservices = {
      image = "ghcr.io/immich-app/immich-server:release";
      hostname = "immich_microservices";
      cmd = [
        "start.sh"
        "microservices"
      ];
      environmentFiles = [ config.sops.secrets.immich_env.path ];
      volumes = [
        "/srv/immich/data/library:/usr/src/app/upload"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };
    typesense = {
      image = "typesense/typesense:0.24.1@sha256:9bcff2b829f12074426ca044b56160ca9d777a0c488303469143dd9f8259d4dd";
      hostname = "immich_typesense";
      environmentFiles = [ config.sops.secrets.immich_env.path ];
      volumes = [
        "/srv/immich/data/typesense:/data"
      ];
    };
    redis = {
      image = "redis:6.2-alpine@sha256:70a7a5b641117670beae0d80658430853896b5ef269ccf00d1827427e3263fa3";
      hostname = "immich_redis";
    };
    database = {
      image = "postgres:14-alpine@sha256:28407a9961e76f2d285dc6991e8e48893503cc3836a4755bbc2d40bcc272a441";
      hostname = "immich_postgres";
      environmentFiles = [ config.sops.secrets.immich_env.path ];
      volumes = [
        "/srv/immich/data/db:/var/lib/postgresql/data"
      ];
    };
  };
}
