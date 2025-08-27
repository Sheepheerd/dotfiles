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
  options.solarsystem.modules.minecraft = lib.mkEnableOption "Enable minecraft config";

  config = lib.mkIf cfg.minecraft {
    environment.systemPackages = with pkgs; [
      prismlauncher
      glfw-wayland-minecraft
    ];
  };
}
