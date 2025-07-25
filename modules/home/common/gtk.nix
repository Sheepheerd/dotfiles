{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.solarsystem.modules.gtk;
in
{
  options.solarsystem.modules.gtk = lib.mkEnableOption "Enable GTK Dracula theme";

  config = lib.mkIf cfg {
    gtk = {
      enable = true;
      theme.package = pkgs.dracula-theme;
      theme.name = "Dracula";
    };
  };
}
