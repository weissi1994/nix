{ inputs, platform, ... }: {
  environment = {
    shellAliases = {
      l    = "ls -lah";
      la   = "ls -a";
      ll   = "ls -l";
      lla  = "ls -la";
      tree = "ls --tree";
    };
  };
}
