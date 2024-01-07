{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc   # Lazy updates
    cargo # Lazy updates
    cmake # Lazy updates
    rustc # rust
    rustup # rust
    rustfmt # rust
    clippy # rust linter
    rust-analyzer # rust
    rust-bindgen # rust
    nodePackages_latest.markdownlint-cli # Markdown linter
    marksman # Markdown formatter
    gnumake # for compiling c
    stylua # lua formatter
    dotnet-sdk_8 # for c#/dotnet
    typos # Source code spell checker
  ];

  home.file.".config/nvim" = {
    source = ./files;
    recursive = true;
  };
}
