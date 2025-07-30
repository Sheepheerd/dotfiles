{ lib, config, ... }:

let
  cfg = config.solarsystem.modules.ghostty;
in
{
  options.solarsystem.modules.ghostty = lib.mkEnableOption "Enable Ghostty terminal with custom settings";

  config = lib.mkIf cfg {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      themes = {
        kanso = {
          palette = [

            "0=#090E13"
            "1=#c4746e"
            "2=#8a9a7b"
            "3=#c4b28a"
            "4=#8ba4b0"
            "5=#a292a3"
            "6=#8ea4a2"
            "7=#a4a7a4"
            "8=#5C6066"
            "9=#e46876"
            "10=#87a987"
            "11=#e6c384"
            "12=#7fb4ca"
            "13=#938aa9"
            "14=#7aa89f"
            "15=#c5c9c7"
          ];
          background = "#090E13";
          foreground = "#c5c9c7";
          cursor-color = "#c5c9c7";
          selection-background = "#22262D";
          selection-foreground = "#c5c9c7";
        };
      };
      settings = {
        font-size = 12;
        font-family = "JetBrainsMono Nerd Font Mono";

        confirm-close-surface = false;
        cursor-style = "block";
        cursor-style-blink = false;

        shell-integration = "zsh";
        shell-integration-features = "no-cursor";

        window-decoration = false;
        window-theme = "dark";
        background-opacity = 0;
        window-padding-x = 10;
        window-padding-y = 10;

        keybind = [
          "ctrl+l=clear_screen"
        ];
      };
    };
  };
}
