{
  lib,
  config,
  globals,
  nixosConfig,
  ...
}:
let

in
{
  options.solarsystem.modules.git = lib.mkEnableOption "git settings";
  config = lib.mkIf config.solarsystem.modules.git {
    programs.git = {
      enable = true;
    };
  };
}
