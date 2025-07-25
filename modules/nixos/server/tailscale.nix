{ config, lib, ... }:

with lib;

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules = {
    tailscaleServer = mkEnableOption "Enable Tailscale VPN service";

  };

  config = mkIf cfg.tailscaleServer {
    services.tailscale.enable = true;

    networking = {
      firewall = {
        trustedInterfaces = [ config.services.tailscale.interfaceName ];

        allowedUDPPorts = [ config.services.tailscale.port ];

        # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
        checkReversePath = "loose";
      };

      networkmanager.unmanaged = [ "tailscale0" ];
    };

  };
}
