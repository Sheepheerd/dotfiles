{
  self,
  lib,
  pkgs,
  config,
  ...
}:
let

  inherit (config.solarsystem) mainUser;

  iwd = config.networking.networkmanager.wifi.backend == "iwd";
in
{
  options.solarsystem = {
    modules.network = lib.mkEnableOption "network config";
    firewall = lib.solarsystem.mkTrueOption;
  };
  config = lib.mkIf config.solarsystem.modules.network {
    networking.nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];

    services.resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
      ];
      dnsovertls = "true";
    };
    networking = {
      # wireless.iwd = {
      #   enable = true;
      #   settings = {
      #     IPv6 = {
      #       Enabled = true;
      #     };
      #     Settings = {
      #       AutoConnect = true;
      #     };
      #   };
      # };
      # nftables.enable = lib.mkDefault true;
      enableIPv6 = lib.mkDefault true;
      firewall = {
        enable = lib.solarsystem.mkStrong config.solarsystem.firewall;
        # checkReversePath = lib.mkDefault false;
        # allowedUDPPorts = [ 51820 ]; # 51820: wireguard
        # allowedTCPPortRanges = [
        #   {
        #     from = 1714;
        #     to = 1764;
        #   } # kde-connect
        # ];
        # allowedUDPPortRanges = [
        #   {
        #     from = 1714;
        #     to = 1764;
        #   } # kde-connect
        # ];
      };

      networkmanager = {
        enable = true;
        # wifi.backend = "iwd";
      };
    };

    systemd.services.NetworkManager-ensure-profiles.after = [ "NetworkManager.service" ];
  };
}
