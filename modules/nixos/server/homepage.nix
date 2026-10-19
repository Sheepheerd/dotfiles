{
  lib,
  config,
  ...
}:

let
  serviceName = "homepage";
  domain = "dash.heerd.dev";
  servicePort = 8092;
  server = config.solarsystem.modules.server;

  # Only list services that are enabled on this host
  mkService =
    enabled: name: sub: icon: description:
    lib.optional enabled {
      ${name} = {
        href = "https://${sub}.heerd.dev";
        inherit icon description;
      };
    };
in
{
  options.solarsystem.modules.server.${serviceName} = lib.mkEnableOption "Enable Homepage dashboard";

  config = lib.mkIf server.${serviceName} {
    services.homepage-dashboard = {
      enable = true;
      listenPort = servicePort;
      allowedHosts = domain;

      settings = {
        title = "solis";
        theme = "dark";
        headerStyle = "clean";
        layout = {
          Money.style = "row";
          Media.style = "row";
          Life.style = "row";
        };
      };

      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
            disk = [
              "/"
              "/mnt/one-t-ssd"
              "/mnt/two-t-hdd"
            ];
          };
        }
        {
          datetime = {
            text_size = "xl";
            format.timeStyle = "short";
          };
        }
      ];

      services = [
        {
          Money =
            mkService server.firefly-iii "Firefly III" "bank" "firefly-iii.png" "Budget & transactions"
            ++ mkService server.firefly-iii "Data Importer" "bank-import" "firefly-iii.png" "SimpleFIN bank import"
            ++ mkService server.wealthfolio "Wealthfolio" "stocks" "mdi-chart-line" "Investments";
        }
        {
          Media =
            mkService server.jellyfin "Jellyfin" "movies" "jellyfin.png" "Movies & shows"
            ++ mkService server.navidrome "Navidrome" "music" "navidrome.png" "Music"
            ++ mkService server.calibre "Calibre" "books" "calibre-web.png" "Books"
            ++ mkService server.immich "Immich" "images" "immich.png" "Photos";
        }
        {
          Life =
            mkService server.lubelogger "LubeLogger" "cars" "lubelogger.png" "Vehicle maintenance"
            ++ mkService server.traccar "Traccar" "track" "traccar.png" "GPS tracking"
            ++ mkService server.paperless "Paperless" "paperless" "paperless-ngx.png" "Documents"
            ++ mkService server.nextcloud "Nextcloud" "nextcloud" "nextcloud.png" "Files"
            ++ mkService server.radicale "Radicale" "radical" "radicale.png" "Calendar & contacts"
            ++ mkService server.futo-notes "Notes" "notes" "mdi-note-text" "FUTO notes";
        }
      ];
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
