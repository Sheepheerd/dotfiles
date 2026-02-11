{
  pkgs,
  lib,
  config,
  self,
  ...
}:
let
  # serverIp = "100.113.25.38";
  serverIp = "100.64.0.5";
in
{
  options.solarsystem.modules.server.nginx = lib.mkEnableOption "enable nginx on server";

  config = lib.mkIf config.solarsystem.modules.server.nginx {

    environment.systemPackages = with pkgs; [ lego ];
    networking.firewall.allowedTCPPorts = [
      53
      80
      443
    ];
    networking.firewall.allowedUDPPorts = [
      53
    ];

    age.secrets.acme-api = {
      file = self + /secrets/server/acme.age;
      owner = "sheep";
      group = "users";
      mode = "0440";
    };

    services.tailscale.extraUpFlags = [
      "--advertise-routes=0.0.0.0/0"
      "--accept-dns=false"
    ];

    networking.networkmanager.dns = "none";

    services.blocky = {
      enable = true;
      settings = {
        ports.dns = 53;
        upstreams.groups.default = [
          "https://dns.quad9.net/dns-query"
        ];
        bootstrapDns = {
          upstream = "https://dns.quad9.net/dns-query";
          ips = [ "9.9.9.9" ];
        };
        blocking = {
          denylists = {
            ads = [ "https://blocklistproject.github.io/Lists/ads.txt" ];
            adult = [
              "https://blocklistproject.github.io/Lists/porn.txt"
            ];
          };
          clientGroupsBlock = {
            default = [
              "ads"
              "adult"
            ];
          };
        };
        customDNS = {
          mapping = {
            "movies.heerd.dev" = serverIp;
            "nextcloud.heerd.dev" = serverIp;
            "radical.heerd.dev" = serverIp;
            "bank.heerd.dev" = serverIp;
            "images.heerd.dev" = serverIp;
            "books.heerd.dev" = serverIp;
            "music.heerd.dev" = serverIp;
            "paperless.heerd.dev" = serverIp;
            "radarr.heerd.dev" = serverIp;
            "prowlarr.heerd.dev" = serverIp;
            "deluge.heerd.dev" = serverIp;
            "qjam.heerd.dev" = serverIp;

          };
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "shepard@heerd.dev";
        dnsProvider = "cloudflare";
        environmentFile = "${config.age.secrets.acme-api.path}";
      };
    };
    users.users.nginx.extraGroups = [ "acme" ];
    services.nginx = {
      enable = true;
      statusPage = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;

    };
  };
}
