{
  lib,
  config,
  ...
}:

let
  serviceName = "traccar";
  domain = "track.heerd.dev";
  servicePort = 8082;
in
{
  options.solarsystem.modules.server.${serviceName} = lib.mkEnableOption "Enable Traccar GPS tracking";

  config = lib.mkIf config.solarsystem.modules.server.${serviceName} {
    services.traccar = {
      enable = true;
      settings = {
        web.port = toString servicePort;
        # Only the Traccar Client phone app (OsmAnd protocol, port 5055).
        # Add a protocol here when adding a hardware/OBD tracker.
        protocols.enable = "osmand";
      };
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
