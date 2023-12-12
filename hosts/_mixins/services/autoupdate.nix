{ pkgs, hostname, ... }:
{
  system.autoUpgrade = {
    enable = true;
    flake = "git+https://gitlab.n0de.biz/daniel/nix?ref=main#${hostname}";
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "20:00";
    randomizedDelaySec = "45min";
  };
}

