{ config, lib, ... }:

with lib;

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules = {
    tailscale = mkEnableOption "Enable Tailscale VPN service";

  };

  config = mkIf cfg.tailscale {
    services.tailscale.enable = true;
  };
}
