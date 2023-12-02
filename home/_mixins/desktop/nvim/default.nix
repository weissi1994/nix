{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc   # Lazy updates
    cargo # Lazy updates
    cmake # Lazy updates
    nodePackages_latest.markdownlint-cli # Markdown linter
    marksman # Markdown formatter
    gnumake # for compiling c
  ];

  home.file.".config/nvim" = {
    source = ./files;
    recursive = true;
  };
}
