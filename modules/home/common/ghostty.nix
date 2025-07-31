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
        theme = "rose-pine";
        font-size = 12;
        font-family = "JetBrainsMono Nerd Font Mono";
        shell-integration-features = [
          "no-cursor"
        ];
        confirm-close-surface = false;
        cursor-style = "block";
        cursor-style-blink = false;

        shell-integration = "zsh";

        window-decoration = false;
        # window-theme = "dark";
        background-opacity = 0;
        window-padding-x = 10;
        window-padding-y = 10;

        keybind = [
          "ctrl+l=clear_screen"
          "ctrl+enter=ignore"
        ];
      };
    };
  };
}
