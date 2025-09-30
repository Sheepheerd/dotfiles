{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules = {
    programs = lib.mkEnableOption "Enable small program modules config";
  };

  config = lib.mkIf cfg.programs {
    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
    programs = {
      thunar.enable = true;
      thunar.plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];

      dconf.enable = true;
      nix-ld.enable = true;
    };

  };
}
