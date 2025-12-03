{
  lib,
  config,
  pkgs,
  ...
}:
let
  servicePort = 3001;
  serviceUser = "immich";
  serviceName = "immich";
in
{
  options.solarsystem.modules.server.immich = lib.mkEnableOption "enable ${serviceName} on server";
  config = lib.mkIf config.solarsystem.modules.server.immich {

    users.users.${serviceUser} = {
      # home = "/var/lib/immich";
      # createHome = true;
      extraGroups = [
        "video"
        "render"
      ];
    };

    services.${serviceName} = {
      accelerationDevices = null;
      package = pkgs.immich;
      enable = true;
      host = "0.0.0.0";
      port = servicePort;
      mediaLocation = "/mnt/one-t-ssd/immich"; # dataDir

      database = {
        enable = true;
        enableVectors = true;
      };

    };
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      dataDir = "/var/lib/postgresql/16";
    };

    # networking.firewall.allowedTCPPorts = [ 3001 ];

    services.nginx = {
      virtualHosts = {
        "images.heerd.dev" = {
          enableACME = true;
          forceSSL = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "http://localhost:3001";
              proxyWebsockets = true;
              recommendedProxySettings = true;
              extraConfig = ''
                client_max_body_size 50000M;
                proxy_read_timeout   600s;
                proxy_send_timeout   600s;
                send_timeout         600s;
              '';
            };
          };
        };
      };
    };

  };

}
