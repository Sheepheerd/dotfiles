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
    services.tailscale = {
      enable = true;

    };

    networking = {
      nftables.enable = true;
      firewall = {
        enable = true;
        trustedInterfaces = [ "tailscale0" ];

        allowedUDPPorts = [ config.services.tailscale.port ];

        # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
        checkReversePath = "loose";
      };

      # networkmanager.unmanaged = [ "tailscale0" ];
    };
    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];
    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;

  };
}
