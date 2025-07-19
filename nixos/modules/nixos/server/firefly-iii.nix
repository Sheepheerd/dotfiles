{
  self,
  lib,
  config,
  ...
}:
let
  serviceUser = "firefly-iii";
  serviceName = "firefly-iii";

  tailscaleHost = "100.113.25.38";

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
          APP_URL = tailscaleHost;
          APP_ENV = "local";
          APP_KEY_FILE = config.age.secrets.firefly-app-key.path;
          TRUSTED_PROXIES = "**";
          DB_CONNECTION = "sqlite";
        };
        enableNginx = true;
        virtualHost = "localhost";
        # virtualHost = tailscaleHost; # Required by module but not used for certs
      };

      nginx = {
        virtualHosts = {
          ${config.services.firefly-iii.virtualHost} = {
            listen = [
              {
                addr = tailscaleHost;
                port = 9999;
              }
            ];
          };
        };
      };
    };
  };

}
