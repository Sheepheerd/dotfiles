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
  options.solarsystem.modules.distrobox = lib.mkEnableOption "Enable distrobox config";

  config = lib.mkIf cfg.distrobox {
    environment.systemPackages = with pkgs; [
      distrobox
      wineWowPackages.waylandFull
    ];

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
  };
}
