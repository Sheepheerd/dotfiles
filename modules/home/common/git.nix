{
  lib,
  config,
  ...
}:
{
  options.solarsystem.modules.git = lib.mkEnableOption "git settings";
  config = lib.mkIf config.solarsystem.modules.git {
    programs.git = {
      enable = true;
    };
  };
}
