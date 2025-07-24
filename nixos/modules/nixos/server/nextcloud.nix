{
  pkgs,
  lib,
  config,
  self,
  ...
}:
let

  serviceUser = "nextcloud";
  serviceGroup = serviceUser;
  serviceName = "nextcloud";
in
{
  options.solarsystem.modules.server.${serviceName} =
    lib.mkEnableOption "enable ${serviceName} on server";
  config = lib.mkIf config.solarsystem.modules.server.${serviceName} {

    age.secrets.nextcloud-admin-pass = {
      file = self + /secrets/server/nextcloud-admin-pass.age;
      owner = serviceUser;
      group = serviceGroup;
      mode = "0440";
    };

    users = {
      groups.${serviceGroup} = { };
      users.${serviceUser} = {
        extraGroups = [ "users" ];
        uid = 777;
        group = lib.mkForce serviceGroup;
        isSystemUser = true;
      };
    };

    fileSystems."/var/lib/nextcloud" = {
      device = "/mnt/two-t-hdd/${serviceName}";
      options = [ "bind" ];
    };

    services.nextcloud = {
      enable = true;
      configureRedis = true;

      hostName = "nextcloud.heerd.dev";
      home = "/var/lib/nextcloud";
      database.createLocally = true;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)
          contacts
          calendar
          cookbook
          tasks
          onlyoffice
          news
          notes
          ;
      };
      extraAppsEnable = true;
      autoUpdateApps.enable = true;

      config = {
        dbtype = "pgsql";
        adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
        adminuser = "admin";
      };
      settings = {
        trusted_domains = [
          "localhost"
          "127.0.0.1"
          "100.113.25.38"
          "solis"
          "nextcloud.heerd.dev"
        ];
        extraTrustedDomains = [ "nextcloud.heerd.dev" ];
        overwriteProtocol = "https";

        enabledPreviewProviders = [
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\Krita"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\MP3"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PNG"
          "OC\\Preview\\TXT"
          "OC\\Preview\\XBitmap"
          "OC\\Preview\\HEIC"
        ];
      };
      maxUploadSize = "10G";
    };

    services.nginx = {

      virtualHosts = {
        "nextcloud.heerd.dev" = {
          enableACME = true;
          forceSSL = true;
          acmeRoot = null;
          locations = {
            "/" = {
              # proxyPass = "http://${serviceName}";
              proxyPass = "http://127.0.0.1:8080";
              proxyWebsockets = true;
              # extraConfig = ''
              #   client_max_body_size 0;
              # '';
            };
          };
        };
      };
    };
  };
}
