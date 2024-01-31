{ config, pkgs, lib, ... }:
{
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    settings = {
      font_size = 11;
      font_family = "FiraCode Nerd Font Mono";
      copy_on_select = "yes";
      cursor_shape = "block";
      cursor_blink_interval = 0;
      enable_audio_bell = "no";
      shell = "fish --login";
      editor = "nvim";
      tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title}";
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";
      enabled_layouts = "Grid,Stack,Splits,Tall,Fat";
      scrollback_lines = -1;
      scrollback_pager_history_size = 0;
      scrollback_fill_enlarged_window = "no";
      background_opacity = "1.0";
      dim_opacity = "0.75";
      kitty_mod = "ctrl+shift";
    };
    extraConfig = ''
    # Right click copy previous command output
    mouse_map right press ungrabbed mouse_select_command_output
    '';
    keybindings = {
      "kitty_mod+up" = "neighboring_window up";
      "kitty_mod+down" = "neighboring_window down";
      "kitty_mod+left" = "neighboring_window left";
      "kitty_mod+right" = "neighboring_window right";
      "kitty_mod+page_up" = "next_tab";
      "kitty_mod+page_down" = "previous_tab";
      "page_up" = "scroll_page_up";
      "page_down" = "scroll_page_down";
    };
  };

  home.file.".config/kitty/ssh.conf".source = ./files/kitty/ssh.conf;
}
