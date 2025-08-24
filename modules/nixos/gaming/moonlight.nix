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
  options.solarsystem.modules.moonlight = lib.mkEnableOption "Enable distrobox config";

  config = lib.mkIf cfg.moonlight {

    environment.systemPackages = with pkgs; [
      moonlight
    ];
  };
}
