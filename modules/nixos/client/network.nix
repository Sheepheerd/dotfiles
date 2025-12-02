{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.solarsystem = {
    modules.network = lib.mkEnableOption "network config";
    modules.firewall = lib.solarsystem.mkTrueOption;
    modules.resolved = lib.solarsystem.mkTrueOption;

  };
  config = lib.mkIf config.solarsystem.modules.network {
    # networking.nameservers = [
    #   "1.1.1.1#one.one.one.one"
    #   "1.0.0.1#one.one.one.one"
    # ];

    services.resolved = {
      enable = lib.mkIf config.solarsystem.modules.resolved true;
    };

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
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
        enable = lib.solarsystem.mkStrong config.solarsystem.modules.firewall;
        # checkReversePath = lib.mkDefault false;
        allowedUDPPorts = [ 51820 ]; # 51820: wireguard
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
