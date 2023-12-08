{ inputs, config, ... }: {
  sops.secrets.codimd_env = { };
  virtualisation.oci-containers.containers = {
    codimd = {
      image = "hackmdio/hackmd:2.4.2";
      hostname = "md.n0de.biz";
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.codimd.rule" = "Host(`md.n0de.biz`)";
        "traefik.http.routers.codimd.priority" = "2";
        "traefik.http.services.codimd.loadbalancer.server.port" = "3000";
        "traefik.http.routers.codimd.entrypoints" = "websecure";
        "traefik.http.routers.codimd.tls.certresolver" = "myresolver";
      };
      environmentFiles = [ config.sops.secrets.codimd_env.path ];
      volumes = [
        "/srv/codimd/data:/home/hackmd/app/public/uploads"
      ];
    };
    codimd-db = {
      image = "postgres:11.6-alpine";
      hostname = "codimd-db";
      environmentFiles = [ config.sops.secrets.codimd_env.path ];
      volumes = [
        "/srv/codimd/db:/var/lib/postgresql/data"
      ];
    };
  };
}
