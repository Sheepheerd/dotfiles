{ config, pkgs, home-manager, misterioFlake, ... }:

let
  system = pkgs.system;
  homeDir = config.home.homeDirectory;
in {
  # home.file.".config/ghostty/config" = {
  #   enable = system == "aarch64-linux";
  #   text = ''
  #     # Font
  #     font-family = JetBrainsMono Nerd Font Mono
  #     font-size = 14
  #
  #     # Cursor
  #     cursor-style = block
  #     cursor-style-blink = false
  #     # Shell
  #     shell-integration = zsh
  #     shell-integration-features = no-cursor
  #
  #     # Window
  #     window-decoration = true
  #     window-theme = dark
  #     background-opacity = 0
  #     window-padding-x = 10
  #     window-padding-y = 10
  #
  #
  #     # Theme
  #     theme = catppuccin-mocha
  #     background = #1e1e2e
  #     foreground = #cdd6f4
  #     selection-background = #585b70
  #     selection-foreground = #cdd6f4
  #     cursor-color = #f5e0dc
  #     cursor-text = #cdd6f4
  #     palette = 0=#45475a
  #     palette = 1=#f38ba8
  #     palette = 2=#a6e3a1
  #     palette = 3=#f9e2af
  #     palette = 4=#89b4fa
  #     palette = 5=#f5c2e7
  #     palette = 6=#94e2d5
  #     palette = 7=#a6adc8
  #     palette = 8=#585b70
  #     palette = 9=#f37799
  #     palette = 10=#89d88b
  #     palette = 11=#ebd391
  #     palette = 12=#74a8fc
  #     palette = 13=#f2aede
  #     palette = 14=#6bd7ca
  #     palette = 15=#bac2de
  #   '';
  # };
  home.file.".local/share/applications/spotify.desktop" = {
    enable = system == "aarch64-linux";
    text = ''
      [Desktop Entry]
      Name=Spotify
      GenericName=music
      Comment=Listen to Spotify
      Exec=chromium --new-window  https://open.spotify.com
      Terminal=false
      Type=Application
      Keywords=music;
      Categories=Music;
    '';
  };

  home.file.".local/share/applications/joplin.desktop" = {
    enable = system == "aarch64-linux";
    text = ''
      [Desktop Entry]
      Name=Joplin
      GenericName=editor
      Comment=Joplin app image
      Exec=${homeDir}/applications/Joplin.AppImage
      Terminal=false
      Type=Application
      Keywords=editor;
      Categories=Utility;
    '';
  };

}
