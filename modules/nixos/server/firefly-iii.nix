{
  self,
  lib,
  config,
  ...
}:

let
  serviceName = "firefly-iii";
  serviceUser = "firefly-iii";
  domain = "bank.heerd.dev";
in
{
  options.solarsystem.modules.server.${serviceName} = lib.mkEnableOption "Enable Firefly III service";

  config = lib.mkIf config.solarsystem.modules.server.${serviceName} {
    # Secrets
    age.secrets = {
      firefly-app-key = {
        file = self + /secrets/server/firefly.appkey.age;
        owner = serviceUser;
        group = "nginx";
        mode = "0440";
      };
    };

    # Firefly III
    services.firefly-iii = {
      enable = true;
      dataDir = "/vault/data/firefly-iii";
      enableNginx = true;
      virtualHost = domain;
      settings = {
        TZ = "America/New_York";
        APP_ENV = "production";
        APP_KEY_FILE = config.age.secrets.firefly-app-key.path;
        DB_CONNECTION = "sqlite";
        APP_URL = "https://${domain}";
      };
    };

    # Nginx virtual host w/ ACME DNS
    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
    };

  };
}
