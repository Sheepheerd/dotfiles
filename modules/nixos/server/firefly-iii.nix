{
  self,
  lib,
  config,
  ...
}:
let
  # servicePort = 80;
  serviceUser = "firefly-iii";
  serviceName = "firefly-iii";

  nginxGroup = "nginx";

in
{
  options.solarsystem.modules.server.${serviceName} =
    lib.mkEnableOption "enable ${serviceName} on server";

  config = lib.mkIf config.solarsystem.modules.server.${serviceName} {

    age.secrets.firefly-app-key = {
      file = self + /secrets/server/firefly.appkey.age;
      owner = serviceUser;
      group = nginxGroup;
      mode = "0440";
    };

    services = {
      ${serviceName} = {
        enable = true;
        dataDir = "/vault/data/${serviceName}";
        settings = {
          TZ = "America/New_York";

          APP_ENV = "production";
          APP_KEY_FILE = config.age.secrets.firefly-app-key.path;
          # DB_CONNECTION = "mysql";
          TRUSTED_PROXIES = "**";
          DB_CONNECTION = "sqlite";
        };
        enableNginx = true;
        virtualHost = "firefly-iii";
      };

      nginx.virtualHosts.${config.services.firefly-iii.virtualHost} = {
        enableACME = false;
        listen = [
          {
            addr = "0.0.0.0";
            port = 9999;
          }
        ];
      };
    };
  };
}
