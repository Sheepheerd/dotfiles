{
  self,
  lib,
  config,
  ...
}:

let
  serviceName = "wealthfolio";
  domain = "stocks.heerd.dev";
  servicePort = 8088;
in
{
  options.solarsystem.modules.server.${serviceName} =
    lib.mkEnableOption "Enable Wealthfolio investment tracker";

  config = lib.mkIf config.solarsystem.modules.server.${serviceName} {
    # Secrets
    age.secrets = {
      wealthfolio-key = {
        file = self + /secrets/server/wealthfolio.key.age;
        mode = "0400";
      };
      wealthfolio-hash = {
        file = self + /secrets/server/wealthfolio.hash.age;
        mode = "0400";
      };
    };

    services.wealthfolio = {
      enable = true;
      port = servicePort;
      secretKeyFile = config.age.secrets.wealthfolio-key.path;
      authPasswordHashFile = config.age.secrets.wealthfolio-hash.path;
      corsAllowOrigins = "https://${domain}";
      cookieSecure = "true";
      authTokenTtlMinutes = 1440;
    };

    # Nginx virtual host w/ ACME DNS
    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString servicePort}";
        proxyWebsockets = true;
      };
    };
  };
}
