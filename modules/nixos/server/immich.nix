{
  lib,
  config,
  globals,
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
      home = "/var/lib/immich";
      createHome = true;
      extraGroups = [
        "video"
        "render"
      ];
    };

    services.${serviceName} = {
      accelerationDevices = null;
      enable = true;
      host = "0.0.0.0";
      port = servicePort;
      mediaLocation = "/mnt/one-t-ssd/immich"; # dataDir
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
              extraConfig = ''
                client_max_body_size    0;

                proxy_http_version 1.1;
                proxy_set_header   Upgrade    $http_upgrade;
                proxy_set_header   Connection "upgrade";
                proxy_redirect     off;

                proxy_read_timeout 600s;
                proxy_send_timeout 600s;
                send_timeout       600s;
              '';
            };
          };
        };
      };
    };

  };

}
