{
  self,
  lib,
  config,
  ...
}:
let
  servicePort = 80;
  serviceUser = "firefly-iii";
  serviceGroup = serviceUser;
  serviceName = "firefly-iii";

  tailscaleHost = "100.113.25.38"; # <-- CHANGE THIS
  tailscaleUrl = "http://${tailscaleHost}";

  nginxGroup = "nginx";

  inherit (config.solarsystem) sopsFile;
  cfg = config.services.firefly-iii;
in
{
  options.solarsystem.modules.server.${serviceName} =
    lib.mkEnableOption "enable ${serviceName} on server";

  config = lib.mkIf config.solarsystem.modules.server.${serviceName} {

    users = {
      groups.${serviceGroup} = { };
      users.${serviceUser} = {
        group = lib.mkForce serviceGroup;
        # extraGroups = lib.mkIf cfg.enableNginx [ nginxGroup ];
        extraGroups = [ nginxGroup ];
        isSystemUser = true;
      };
    };

    age.secrets.firefly-app-key = {
      file = self + /secrets/server/env/firefly.appkey;
      owner = serviceUser;
      group = nginxGroup;
      mode = "0440";
    };

    services = {
      ${serviceName} = {
        enable = true;
        user = serviceUser;
        # group = if cfg.enableNginx then nginxGroup else serviceGroup;
        group = nginxGroup;
        # dataDir = "/Vault/data/${serviceName}";
        settings = {
          TZ = "America/New_York";
          APP_URL = "http://solis:9999";
          APP_ENV = "local";
          APP_KEY_FILE = config.age.secrets.firefly-app-key.path;
          DB_CONNECTION = "sqlite";
        };
        enableNginx = true;
        virtualHost = tailscaleHost; # Required by module but not used for certs
      };

      nginx = {
        virtualHosts."firefly-local" = {
          enableACME = false;
          forceSSL = false;
          listen = [
            {
              addr = "100.113.25.38"; # Tailscale IP of 'soils'
              port = 9999;
            }
          ];
          locations = {
            "/" = {
              proxyPass = "http://${serviceName}";
            };
            "/api" = {
              proxyPass = "http://${serviceName}";
              extraConfig = ''
                index index.php;
                try_files $uri $uri/ /index.php?$query_string;
                add_header Access-Control-Allow-Methods 'GET, POST, HEAD, OPTIONS';
              '';
            };
          };
        };
      };
    };

  };
}
