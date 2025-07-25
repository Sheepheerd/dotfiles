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

      settings = {
        term = "xterm-256color";
        theme = "catppuccin-mocha";
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
          "ctrl+h=goto_split:left"
          "ctrl+l=goto_split:right"
        ];
      };
    };
  };
}
