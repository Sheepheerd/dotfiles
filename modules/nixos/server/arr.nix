{
  config,
  lib,
  ...
}:

let
  cfg = config.solarsystem.modules.server.arr;
in
{
  options.solarsystem.modules.server.arr = lib.mkEnableOption "Enable arr service";

  config = lib.mkIf cfg {

    nixarr = {
      enable = true;
      radarr = {
        enable = true;
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
        # "prowlarr.heerd.dev" = {
        #   enableACME = true;
        #   forceSSL = true;
        #   acmeRoot = null;
        #   locations = {
        #     "/" = {
        #       proxyPass = "http://127.0.0.1:9696";
        #       extraConfig = '''';
        #     };
        #   };
        # };
        "deluge.heerd.dev" = {
          enableACME = true;
          forceSSL = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:8112";
              extraConfig = '''';
            };
          };
        };
      };
    };
  };
}
