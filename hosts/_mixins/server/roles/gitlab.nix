{ inputs, pkgs, lib, stateVersion, config, ... }: {
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
  };

  # Runner
  sops.secrets.gitlab_runner_env = {
    restartUnits = [ "gitlab-runner.service" ];
  };

  virtualisation.docker.enable = false;
  services.gitlab-runner = {
    enable = true;
    services = {
      # runner for building in docker via host's nix-daemon
      # nix store will be readable in runner, might be insecure
      nix = with lib;{
        # File should contain at least these two variables:
        # `CI_SERVER_URL`
        # `REGISTRATION_TOKEN`
        registrationConfigFile = config.sops.secrets.gitlab_runner_env.path;
        dockerImage = "alpine";
        dockerVolumes = [
          "/nix/store:/nix/store:ro"
          "/var/run/docker.sock:/var/run/docker.sock"
          "/nix/var/nix/db:/nix/var/nix/db:ro"
          "/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro"
          "/srv/netboot:/srv/netboot"
        ];
        dockerDisableCache = true;
        preBuildScript = pkgs.writeScript "setup-container" ''
          echo 'nameserver 1.1.1.1' > /etc/resolv.conf
          echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
          mkdir -p -m 0755 /nix/var/log/nix/drvs
          mkdir -p -m 0755 /nix/var/nix/gcroots
          mkdir -p -m 0755 /nix/var/nix/profiles
          mkdir -p -m 0755 /nix/var/nix/temproots
          mkdir -p -m 0755 /nix/var/nix/userpool
          mkdir -p -m 1777 /nix/var/nix/gcroots/per-user
          mkdir -p -m 1777 /nix/var/nix/profiles/per-user
          mkdir -p -m 0755 /nix/var/nix/profiles/per-user/root
          mkdir -p -m 0700 "$HOME/.nix-defexpr"
          . ${pkgs.nix}/etc/profile.d/nix-daemon.sh
          ${pkgs.nix}/bin/nix-channel --add https://nixos.org/channels/nixos-${stateVersion} nixpkgs
          ${pkgs.nix}/bin/nix-channel --update nixpkgs
          ${pkgs.nix}/bin/nix-env -i ${concatStringsSep " " (with pkgs; [ nix cacert git openssh ])}
        '';
        environmentVariables = {
          ENV = "/etc/profile";
          USER = "root";
          NIX_REMOTE = "daemon";
          PATH = "/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin";
          NIX_SSL_CERT_FILE = "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt";
        };
        tagList = [ "nix" ];
      };
    };
  };

  systemd.services.gitlab-runner.serviceConfig.SupplementaryGroups = ["podman"];
}
