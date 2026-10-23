{
  lib,
  config,
  ...
}:

let
  serviceName = "lubelogger";
  domain = "cars.heerd.dev";
  servicePort = 5000;
in
{
  options.solarsystem.modules.server.${serviceName} =
    lib.mkEnableOption "Enable LubeLogger vehicle maintenance tracker";

  config = lib.mkIf config.solarsystem.modules.server.${serviceName} {
    services.lubelogger = {
      enable = true;
      port = servicePort;
      settings = {
        TZ = "America/New_York";
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };
    };

    # Nginx virtual host w/ ACME DNS
    services.nginx.virtualHosts.${domain} = {
      useACMEHost = "heerd.dev";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString servicePort}";
        extraConfig = ''
          client_max_body_size 100M;
        '';
      };
    };
  };
}
