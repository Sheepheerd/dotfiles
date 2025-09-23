{ lib, config, ... }:

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules = {
    programs = lib.mkEnableOption "Enable small program modules config";
  };

  config = lib.mkIf cfg.programs {
    programs = {
      dconf.enable = true;
      nix-ld.enable = true;
    };

  };
}
