{ pkgs, ... }: {
  imports = [
  ];

  # Add additional apps and include Yaru for syntax highlighting
  environment.systemPackages = with pkgs; [
    yaru-theme
  ];

  # Add GNOME Disks, Pantheon Tweaks and Seahorse
  programs = {
  };
}
