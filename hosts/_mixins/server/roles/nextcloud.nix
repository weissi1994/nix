{ inputs, config, ... }: {
  sops.secrets.nextcloud_env = { };
  virtualisation.oci-containers.containers = {
    nextcloud-db = {
      image = "mariadb:latest";
      hostname = "nextcloud-db";
      cmd = [
        "--transaction-isolation=READ-COMMITTED"
        "--binlog-format=ROW"
      ];
      environmentFiles = [ config.sops.secrets.nextcloud_env.path ];
      volumes = [
        "/srv/nextcloud/db:/var/lib/mysql"
      ];
    };
    redis-nextcloud = {
      image = "redis:latest";
      hostname = "redis-nextcloud";
      cmd = [
        "redis-server"
      ];
      environment = {
        "ALLOW_EMPTY_PASSWORD" = "yes";
      };
    };
    nextcloud = {
      image = "nextcloud:23";
      hostname = "nextcloud";
      environmentFiles = [ config.sops.secrets.nextcloud_env.path ];
      dependsOn = [
        "nextcloud-db"
        "redis-nextcloud"
      ];
      volumes = [
        "/srv/nextcloud/data:/var/www/html"
        "/srv/nextcloud/memory-limit.ini:/usr/local/etc/php/conf.d/memory-limit.ini:ro"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.nextcloud.middlewares" = "nextcloud,nextcloud_redirect";
        "traefik.http.middlewares.nextcloud.headers.customFrameOptionsValue" = "ALLOW-FROM https://n0de.biz";
        "traefik.http.middlewares.nextcloud.headers.contentSecurityPolicy" = "frame-ancestors 'self' n0de.biz *.n0de.biz";
        "traefik.http.middlewares.nextcloud.headers.stsSeconds" = "155520011";
        "traefik.http.middlewares.nextcloud.headers.stsIncludeSubdomains" = "true";
        "traefik.http.middlewares.nextcloud.headers.stsPreload" = "true";
        "traefik.http.middlewares.nextcloud_redirect.redirectregex.regex" = "/.well-known/(card|cal)dav";
        "traefik.http.middlewares.nextcloud_redirect.redirectregex.replacement" = "/remote.php/dav/";
        "traefik.http.routers.nextcloud.rule" = "Host(`nextcloud.n0de.biz`)";
        "traefik.http.routers.nextcloud.priority" = "2";
        "traefik.http.services.nextcloud.loadbalancer.server.port" = "80";
        "traefik.http.routers.nextcloud.entrypoints" = "websecure";
        "traefik.http.routers.nextcloud.tls.certresolver" = "myresolver";
      };
    };
  };
}
