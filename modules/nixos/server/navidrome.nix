{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let

  serviceUser = "navidrome";
  serviceGroup = serviceUser;
  cfg = config.solarsystem.modules.server.navidrome;
in
{
  options.solarsystem.modules.server.navidrome = lib.mkEnableOption "Enable navidrome service";

  config = lib.mkIf cfg {

    users = {
      groups.${serviceGroup} = { };
      users.${serviceUser} = {
        group = lib.mkForce serviceGroup;
        extraGroups = [
          "users"
        ];
        isSystemUser = true;
      };
    };

    # fileSystems."/var/lib/navidrome" = {
    #   device = "/mnt/one-t-ssd/navidrome";
    #   options = [ "bind" ];
    # };
    services.navidrome = {
      enable = true;
      group = "navidrome";
      user = "navidrome";
      settings = {

        MusicFolder = "/mnt/one-t-ssd/navidrome_media/music";
      };

    };

    services.nginx = {

      virtualHosts = {
        "music.heerd.dev" = {
          enableACME = true;
          forceSSL = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:4533";
            };
          };
        };
      };
    };
  };
}
