{
  self,
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.solarsystem.modules;
  domain = "headscale.heerd.dev";
  serverIp = "100.64.0.5";
in
{
  options.solarsystem.modules = {
    headscaleServer = mkEnableOption "Enable Headscale VPN service";

  };
  config = mkIf cfg.headscaleServer {
    services.headscale = {
      enable = true;
      address = "127.0.0.1";
      port = 8080;
      settings = {
        server_url = "https://${domain}";

        dns = {
          override_local_dns = false;
          base_domain = "tailnet.heerd.dev";
          magic_dns = true;
          nameservers = {
            global = [
              "1.1.1.1"
              serverIp
            ];
          };
        };
        derp = {
          # Use default Tailscale DERP servers
          urls = [ "https://controlplane.tailscale.com/derpmap/default" ];
          auto_update_enabled = true;
          update_frequency = "24h";

        };
        database = {
          type = "sqlite";
          sqlite = {
            path = "/var/lib/headscale/db.sqlite";
            write_ahead_log = true;
          };
        };
        policy = {
          mode = "file";
          path = "${config.age.secrets.head-acl.path}";
        };
      };

    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    services.nginx = {
      virtualHosts."headscale.heerd.dev" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
          proxyWebsockets = true;
        };

      };
    };

    age.secrets.head-acl = {
      file = self + /secrets/server/head-acl.age;
      owner = "headscale";
      group = "headscale";
      mode = "0440";
    };
    age.secrets.cloud-dns = {
      file = self + /secrets/server/cloud-dns.age;
      owner = "sheep";
      group = "sheep";
      mode = "0440";
    };

    services.cloudflare-ddns = {
      enable = true;

      credentialsFile = "${config.age.secrets.cloud-dns.path}";

      domains = [
        "headscale.heerd.dev"
      ];

      proxied = "false";

    };

  };
}
