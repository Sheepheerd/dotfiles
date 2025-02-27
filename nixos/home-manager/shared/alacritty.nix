{ pkgs, ... }: {
  programs = {
    alacritty = {
      enable = false;
      settings = {
        env.TERM = "xterm-256color";
        font = {
          size = 14;
          normal = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Medium";

          };
          bold = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Bold";
          };
          italic = {

            family = "JetBrainsMono Nerd Font Mono";
            style = "Medium Italic";
          };

        };
        scrolling = {
          history = 100000;
          multiplier = 3;
        };
        selection = {
          save_to_clipboard = true;

          semantic_escape_chars = '',│`|:"' ()[]{}<>	'';
        };
        window = {

          dynamic_title = true;
          dynamic_padding = true;

          dimensions = {

            columns = 120;
            lines = 35;

          };
          padding = {

            x = 10;
            y = 10;
          };
        };
        general = {
          live_config_reload = true;

          import = [ pkgs.alacritty-theme.tokyo_night ];
        };
        cursor = {
          style = "Block";
          unfocused_hollow = true;
        };
        keyboard = {

          bindings = [

            {
              key = "Left";
              mods = "Alt";
              chars = "u001b[B";
            }
            {
              key = "Right";
              mods = "Alt";
              chars = "u001b[F";
            }
            {
              key = "Left";
              mods = "Command";
              chars = "u001b[1;2D";
            }
            {
              key = "Right";
              mods = "Command";
              chars = "u001b[1;2C";
            }
            {
              key = "Back";
              mods = "Command";
              chars = "u0015";
            }
          ];
        };
      };
    };
  };
}
