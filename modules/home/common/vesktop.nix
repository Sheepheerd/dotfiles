{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.solarsystem.modules.vesktop = lib.mkEnableOption "Vesktop settings";
  config = lib.mkIf config.solarsystem.modules.vesktop {
    programs = {
      vesktop = {
        enable = true;

      };
    };
  };
}
