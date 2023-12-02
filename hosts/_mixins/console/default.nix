{ inputs, platform, ... }: {
  environment = {
    shellAliases = {
      l    = "ls -lah";
      la   = "ls -a";
      ll   = "ls -l";
      lla  = "ls -la";
      tree = "ls --tree";
    };
    # systemPackages = with inputs; [
    #   antsy-alien-attack-pico.packages.${platform}.default
    #   crafts-flake.packages.${platform}.snapcraft
    #   fh.packages.${platform}.default
    # ];
  };
}
