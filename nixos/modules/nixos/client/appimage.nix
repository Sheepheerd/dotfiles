{ lib, config, ... }:

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules.appimage = lib.mkEnableOption "Enable appimage config";

  config = lib.mkIf cfg.appimage {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
