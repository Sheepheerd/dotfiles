{
  lib,
  config,
  pkgs,
  self,
  ...
}:

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules.stylix = lib.mkEnableOption "Enable stylix config";

  config = lib.mkIf cfg.stylix {
    stylix = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      image = "${self}/wallpaper/dark.png";
      fonts = {

        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };

        monospace = {
          package = pkgs.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

  };
}
