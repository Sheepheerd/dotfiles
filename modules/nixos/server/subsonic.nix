{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let

  serviceUser = "subsonic";
  serviceGroup = serviceUser;
  cfg = config.solarsystem.modules.server.subsonic;
in
{
  options.solarsystem.modules.server.subsonic = lib.mkEnableOption "Enable subsonic service";

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

    fileSystems."/var/lib/subsonic" = {
      device = "/mnt/one-t-ssd/subsonic";
      options = [ "bind" ];
    };
    fileSystems."/var/music" = {
      device = "/mnt/one-t-ssd/subsonic_media/music";
      options = [ "bind" ];
    };
    fileSystems."/var/playlists" = {
      device = "/mnt/one-t-ssd/subsonic_media/playlists";
      options = [ "bind" ];
    };
    services.subsonic = {
      enable = true;

    };

    services.nginx = {

      virtualHosts = {
        "music.heerd.dev" = {
          enableACME = true;
          forceSSL = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:4040";
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
