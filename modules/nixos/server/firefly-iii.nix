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
  importerDomain = "bank-import.heerd.dev";
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
      # FIREFLY_III_ACCESS_TOKEN + SIMPLEFIN_TOKEN for the data importer
      firefly-importer-env = {
        file = self + /secrets/server/firefly-importer.age;
        mode = "0400";
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

    # Data importer (SimpleFIN)
    services.firefly-iii-data-importer = {
      enable = true;
      dataDir = "/vault/data/firefly-iii-data-importer";
      enableNginx = true;
      virtualHost = importerDomain;
      settings = {
        TZ = "America/New_York";
        APP_ENV = "production";
        APP_URL = "https://${importerDomain}";
        FIREFLY_III_URL = "https://${domain}";
        VANITY_URL = "https://${domain}";
      };
    };

    # Secrets are read by the setup unit and baked into the importer's config cache
    systemd.services.firefly-iii-data-importer-setup = {
      serviceConfig.EnvironmentFile = config.age.secrets.firefly-importer-env.path;
      restartTriggers = [ config.age.secrets.firefly-importer-env.file ];
    };

    services.nginx.virtualHosts.${importerDomain} = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
    };

    # Let the importer reach Firefly III locally instead of through tailscale DNS
    networking.hosts."127.0.0.1" = [ domain ];

  };
}
