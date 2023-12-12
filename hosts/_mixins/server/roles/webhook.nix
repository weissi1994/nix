{ inputs, pkgs, config, ... }: {

  systemd.services.create-webhook-pod = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "${backend}-webhook-web.service" "${backend}-redis-webhook.service" "${backend}-laravel-echo-server.service" ];
    script = ''
      ${pkgs.podman}/bin/podman pod exists webhook || \
        ${pkgs.podman}/bin/podman pod create -n webhook
    '';
  };

  virtualisation.oci-containers.containers = {
    webhook-web = {
      image = "webhooksite/webhook.site";
      extraOptions = [ "--pod=webhook" ];
      cmd = [
        "php"
        "artisan"
        "queue:work"
        "--daemon"
        "--tries=3"
        "--timeout=10"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.webhook.rule" = "Host(`webhook.n0de.biz`)";
        "traefik.http.routers.webhook.priority" = "2";
        "traefik.http.services.webhook.loadbalancer.server.port" = "80";
        "traefik.http.routers.webhook.entrypoints" = "websecure";
        "traefik.http.routers.webhook.tls.certresolver" = "myresolver";
      };
      environment = {
        "APP_ENV" = "production";
        "APP_DEBUG" = "false";
        "APP_URL" = "https://webhook.n0de.biz";
        "APP_LOG" = "errorlog";
        "DB_CONNECTION" = "sqlite";
        "REDIS_HOST" = "redis-webhook";
        "BROADCAST_DRIVER" = "redis";
        "CACHE_DRIVER" = "redis";
        "QUEUE_DRIVER" = "redis";
        "ECHO_HOST_MODE" = "path";
      };
      dependsOn = [
        "redis-webhook"
      ];
    };
    redis-webhook = {
      image = "redis:alpine";
      extraOptions = [ "--pod=webhook" ];
    };
    laravel-echo-server = {
      image = "mintopia/laravel-echo-server";
      extraOptions = [ "--pod=webhook" ];
      dependsOn = [
        "redis-webhook"
      ];
      environment = {
        "LARAVEL_ECHO_SERVER_AUTH_HOST" = "http://webhook-web";
        "LARAVEL_ECHO_SERVER_HOST" = "0.0.0.0";
        "LARAVEL_ECHO_SERVER_PORT" = "6001";
        "ECHO_REDIS_PORT" = "6379";
        "ECHO_REDIS_HOSTNAME" = "redis-webhook";
        "ECHO_PROTOCOL" = "http";
        "ECHO_ALLOW_CORS" = "true";
        "ECHO_ALLOW_ORIGIN" = "*";
        "ECHO_ALLOW_METHODS" = "*";
        "ECHO_ALLOW_HEADERS" = "*";
      };
    };
  };
}
