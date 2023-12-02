{ inputs, pkgs, ...}: {
  imports = [
    ./fish.nix
    ./kitty.nix
  ];
  home.packages = with pkgs; [
    figlet # For greeter script
    cava   # for cli equealizer #unixporn
    unstable.eza    # nice ls
  ];

  home.file.".config/greeter.sh".source = ./files/greeter.sh;
}
