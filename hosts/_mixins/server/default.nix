{ inputs, roles, ... }: {
  imports = roles;

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      traefik = {
        image = "traefik:latest";
        hostname = "traefik";
        cmd = [
          "--api.insecure=true"
          "--providers.docker=true"
          "--providers.docker.exposedbydefault=false"
          "--log.filePath=/var/log/traefik/traefik.log"
          "--providers.file.directory=/etc/traefik/conf"
          "--accesslog=true"
          "--accesslog.filepath=/var/log/traefik/access.log"
          "--accesslog.bufferingsize=100"
          "--accesslog.format=json"
          "--accesslog.fields.defaultmode=keep"
          "--accesslog.fields.names.ClientUsername=drop"
          "--accesslog.fields.headers.defaultmode=keep"
          "--accesslog.fields.headers.names.User-Agent=redact"
          "--accesslog.fields.headers.names.Authorization=drop"
          "--accesslog.fields.headers.names.Content-Type=keep"
          "--entrypoints.web.address=:80"
          "--entrypoints.web.http.redirections.entryPoint.to=websecure"
          "--entrypoints.web.http.redirections.entryPoint.scheme=https"
          "--entrypoints.web.http.redirections.entrypoint.permanent=true"
          "--entrypoints.websecure.address=:443"
          "--certificatesresolvers.myresolver.acme.dnschallenge=true"
          "--certificatesresolvers.myresolver.acme.dnschallenge.provider=cloudflare"
          "--certificatesresolvers.myresolver.acme.email=ion@n0de.biz"
          "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
          "--certificatesresolvers.myresolver.acme.dnschallenge.resolvers=1.1.1.1:53,8.8.8.8:53"
        ];
        ports = [ "80:80" "443:443" "8080:8080" ];
        environmentFiles = [ "/run/secrets/docker/traefik" ];
        volumes = [
          "/srv/traefik/letsencrypt:/letsencrypt"
          "/srv/traefik/conf:/etc/traefik/conf"
          "/var/log/traefik:/var/log/traefik"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];
      };
    };
  };
}
