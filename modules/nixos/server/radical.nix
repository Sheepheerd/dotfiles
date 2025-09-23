{
  config,
  lib,
  ...
}:

let

  serviceUser = "radicale";
  serviceGroup = serviceUser;
  cfg = config.solarsystem.modules.server.radicale;
in
{
  options.solarsystem.modules.server.radicale = lib.mkEnableOption "Enable radical service";

  config = lib.mkIf cfg {

    users = {
      groups.${serviceGroup} = { };
      users.${serviceUser} = {
        group = lib.mkForce serviceGroup;
        extraGroups = [
          "users"
        ];
        # isSystemUser = true;
      };
    };

    services.radicale = {
      enable = true;
      settings = {
        server = {
          hosts = [
            "0.0.0.0:5232"
            # "[::]:5232"
          ];
        };
        auth = {
          type = "none";
        };
        storage = {
          filesystem_folder = "/mnt/one-t-ssd/radicale/collections";
        };
      };
    };
    systemd.tmpfiles.rules = [ "d /mnt/one-t-ssd/radicale/collections 0750 radicale radicale -" ];

    services.nginx = {

      virtualHosts = {
        "radical.heerd.dev" = {
          enableACME = true;
          forceSSL = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:5232";
              extraConfig = ''
                client_max_body_size 16M;
              '';
            };
          };
        };
      };
    };
  };
}
