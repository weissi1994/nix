{ pkgs, ... }:

{
  extraPlugins = with pkgs.vimPlugins; [
    vim-helm
    vim-kitty-navigator
    lazygit-nvim
    vim-puppet
    vim-ruby
    plenary-nvim
    nui-nvim
    nvim-web-devicons
  ];
}
