{
  config,
  lib,
  self,
  pkgs,
  ...
}:

let

  serviceUser = "arr";
  serviceGroup = serviceUser;
  cfg = config.solarsystem.modules.server.arr;
in
{
  options.solarsystem.modules.server.arr = lib.mkEnableOption "Enable arr service";

  config = lib.mkIf cfg {

    # users = {
    #   groups.radarr = { };
    #   users.radarr = {
    #     group = "radarr";
    #     extraGroups = [
    #       "users"
    #       "media"
    #     ];
    #     # isSystemUser = true;
    #   };
    # };

    age.secrets = {
      sabnzbd-env-file = {
        file = self + /secrets/server/arr/sabnzbd.age;
        owner = "sabnzbd";
        group = "sabnzbd";
        mode = "0440";
      };
    };
    nixarr = {
      enable = true;
      radarr = {
        enable = true;
        # openFirewall = true;
        # stateDir = "/mnt/two-t-hdd/arr/radarr";
      };

      prowlarr = {
        enable = true;
      };
    };

    services.nginx = {

      virtualHosts = {
        "radarr.heerd.dev" = {
          enableACME = true;
          forceSSL = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:7878";
              extraConfig = '''';
            };
          };
        };
        "prowlarr.heerd.dev" = {
          enableACME = true;
          forceSSL = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:9696";
              extraConfig = '''';
            };
          };
        };
        # "sabnzb.heerd.dev" = {
        #   enableACME = true;
        #   forceSSL = true;
        #   acmeRoot = null;
        #   locations = {
        #     "/" = {
        #       proxyPass = "http://127.0.0.1:6336";
        #       extraConfig = '''';
        #     };
        #   };
        # };
      };
    };
  };
}
