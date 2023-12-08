{ inputs, config, ... }: {
  virtualisation.oci-containers.containers = {
    ChanScanner = {
      image = "registry.n0de.biz/gif/4scanner:latest";
      hostname = "4scanner";
      volumes = [
        "/srv/4scanner/db:/root/.4scanner"
        "/srv/4scanner/config.json:/output/config.json"
        "/srv/nextcloud/data/data/daniel/files/Downloads:/output/downloads"
      ];
    };
  };
}
