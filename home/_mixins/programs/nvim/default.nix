{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc   # Lazy updates
    cargo # Lazy updates
    cmake # Lazy updates
    nodePackages_latest.markdownlint-cli # Markdown linter
    marksman # Markdown formatter
    gnumake # for compiling c
    stylua # lua formatter
    dotnet-sdk_8 # for c#/dotnet
    typos # Source code spell checker
    mono # c# stuff
    mono4 # c# stuff
  ];

  home.file.".config/nvim" = {
    source = ./files;
    recursive = true;
  };
}
