{
  config,
  lib,
  ...
}:

let

  serviceUser = "qjam";
  serviceGroup = serviceUser;
  cfg = config.solarsystem.modules.server.qjam;
in
{
  options.solarsystem.modules.server.qjam = lib.mkEnableOption "Enable qjam";

  config = lib.mkIf cfg {

    # users = {
    #   groups.${serviceGroup} = { };
    #   users.${serviceUser} = {
    #     group = lib.mkForce serviceGroup;
    #     extraGroups = [
    #       "users"
    #     ];
    #     # isSystemUser = true;
    #   };
    # };

    # services.radicale = {
    #   enable = true;
    #   settings = {
    #     server = {
    #       hosts = [
    #         "0.0.0.0:5232"
    #         # "[::]:5232"
    #       ];
    #     };
    #     auth = {
    #       type = "none";
    #     };
    #     storage = {
    #       filesystem_folder = "/mnt/one-t-ssd/radicale/collections";
    #     };
    #   };
    # };

    services.nginx = {

      virtualHosts = {
        "qjam.heerd.dev" = {
          enableACME = true;
          forceSSL = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:9999";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Forwarded-Host $host;
                proxy_set_header Host $host;
              '';
            };
          };
        };
      };
    };
  };
}
