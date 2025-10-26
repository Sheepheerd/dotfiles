{
  lib,
  config,
  pkgs,
  ...
}:
let
  pinnedNixpkgs =
    import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/832e3b6.tar.gz";
        sha256 = "1xyk39afidw5qxfnzj4pnzqmx973j1ja34sb2pg40j20fh676fmr";
      })
      {
        system = pkgs.system;
      };
  serviceUser = "calibre";
  serviceGroup = "calibre";
  serviceName = "calibre";
  library = "/var/lib/calibre-server";
in
{
  options.solarsystem.modules.server.calibre = lib.mkEnableOption "enable ${serviceName} on server";
  config = lib.mkIf config.solarsystem.modules.server.calibre {

    nixpkgs.overlays = [
      (final: prev: {
        calibre = pinnedNixpkgs.calibre;
        # If your module uses calibre-server specifically, override it too:
        calibre-server = pinnedNixpkgs.calibre-server or pinnedNixpkgs.calibre;
      })
    ];

    users = {
      groups.${serviceGroup} = { };
      users.${serviceUser} = {
        group = lib.mkForce serviceGroup;
        isSystemUser = true;
      };
    };

    fileSystems."/var/lib/calibre-server" = {
      device = "/mnt/one-t-ssd/calibre";
      options = [ "bind" ];
    };
    services = {
      calibre-server = {
        enable = true;

        host = "localhost";
        port = 8195;
        libraries = [ library ];
        auth.enable = false;

        user = "calibre";
        group = "calibre";
      };
      calibre-web = {
        enable = true;
        listen = {
          ip = "0.0.0.0";
          port = 8095;
        };
        options = {
          enableBookConversion = true;
          enableBookUploading = true;
          # reverseProxyAuth.enable = true;
          calibreLibrary = "/var/lib/calibre-server";
        };

        user = "calibre";
        group = "calibre";
      };
    };

    # networking.firewall.allowedTCPPorts = [ 3001 ];

    services.nginx = {
      virtualHosts = {
        "books.heerd.dev" = {
          enableACME = true;
          forceSSL = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "http://localhost:8095";
              extraConfig = ''
                client_max_body_size    0;

              '';
            };
          };
        };
      };
    };
    systemd.services.calibre-web.after = [ "calibre-server.service" ];

  };

}
