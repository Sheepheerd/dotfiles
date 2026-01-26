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
    networking.firewall.allowedTCPPorts = [ 25565 ];
    environment.systemPackages = with pkgs; [
      prismlauncher
      glfw3-minecraft
    ];
  };
}
