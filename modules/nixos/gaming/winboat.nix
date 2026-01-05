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
  options.solarsystem.modules.winboat = lib.mkEnableOption "Enable winboat";

  config = lib.mkIf cfg.winboat {

    environment.systemPackages = with pkgs; [
      winboat
    ];
  };
}
