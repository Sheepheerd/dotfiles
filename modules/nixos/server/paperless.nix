{
  lib,
  config,
  ...
}:
let
  serviceUser = "paperless";
  serviceGroup = "paperless";
  serviceName = "paperless";
  serviceDomain = "paperless.heerd.dev";
  servicePort = 28981;
in
{
  options.solarsystem.modules.server.paperless = lib.mkEnableOption "enable ${serviceName} on server";

  config = lib.mkIf config.solarsystem.modules.server.paperless {
    users.users.${serviceUser} = {
      extraGroups = [ "users" ];
      group = serviceGroup;
    };
    users.groups.${serviceGroup} = { };

    services.paperless = {
      enable = true;
      user = serviceUser;
      mediaDir = "/mnt/two-t-hdd/paperless/media";
      dataDir = "/mnt/two-t-hdd/paperless/data";
      port = servicePort;
      address = "0.0.0.0";
      configureNginx = true;

      domain = serviceDomain;
      settings = {
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_URL = "https://${serviceDomain}";
        PAPERLESS_OCR_USER_ARGS = builtins.toJSON {
          optimize = 1;
          invalidate_digital_signatures = true;
          pdfa_image_compression = "lossless";
        };

      };
    };

    services.nginx = {
      virtualHosts."paperless.heerd.dev" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;

        # locations."/" = {
        #   proxyPass = "http://127.0.0.1:${toString servicePort}";
        #   extraConfig = ''
        #     client_max_body_size    0;
        #     proxy_connect_timeout   300;
        #     proxy_send_timeout      300;
        #     proxy_read_timeout      300;
        #     send_timeout            300;
        #   '';
        # };

      };
    };
  };
}
