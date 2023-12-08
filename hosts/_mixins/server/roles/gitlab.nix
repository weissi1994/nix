{ inputs, config, ... }: {
  virtualisation.oci-containers.containers = {
    gitlab = {
      image = "gitlab/gitlab-ee:latest";
      hostname = "git.n0de.biz";
      ports = [ "2222:22" ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.gitlab.rule" = "Host(`git.n0de.biz`, `gitlab.n0de.biz`, `registry.n0de.biz`)";
        "traefik.http.routers.gitlab.priority" = "2";
        "traefik.http.services.gitlab.loadbalancer.server.port" = "80";
        "traefik.http.routers.gitlab.entrypoints" = "websecure";
        "traefik.http.routers.gitlab.tls.certresolver" = "myresolver";
      };
      volumes = [
        "/srv/gitlab/config:/etc/gitlab"
        "/srv/gitlab/logs:/var/log/gitlab"
        "/srv/gitlab/data:/var/opt/gitlab"
      ];
    };
    gitlab-runner = {
      image = "gitlab/gitlab-runner:latest";
      hostname = "gitlab-runner";
      extraOptions = [ "--privileged" ];
      volumes = [
        "/srv/gitlab-runner/config:/etc/gitlab-runner"
        "/var/run/docker.sock:/var/run/docker.sock"
      ];
    };
  };
}
