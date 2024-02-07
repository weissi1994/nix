{ pkgs, ... }:
let
  config = import ./config.nix;
in
{
  programs.neovim = {
    defaultEditor = true;
  };

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    options = config.config.options;
    colorschemes = config.config.colorschemes;
    plugins = config.config.plugins;
    keymaps = config.config.keymaps;
    extraPlugins = config.config.extraPlugins;
  };
}
