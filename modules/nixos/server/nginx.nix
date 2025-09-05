{
  pkgs,
  lib,
  config,
  self,
  ...
}:
{
  options.solarsystem.modules.server.nginx = lib.mkEnableOption "enable nginx on server";

  config = lib.mkIf config.solarsystem.modules.server.nginx {

    environment.systemPackages = with pkgs; [ lego ];
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    age.secrets.acme-api = {
      file = self + /secrets/server/acme.age;
      owner = "sheep";
      group = "users";
      mode = "0440";
    };
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
        customDNS = {
          mapping = {
            "movies.heerd.dev" = "100.113.25.38";
            "nextcloud.heerd.dev" = "100.113.25.38";
            "radical.heerd.dev" = "100.113.25.38";
            "bank.heerd.dev" = "100.113.25.38";
            "images.heerd.dev" = "100.113.25.38";
            "books.heerd.dev" = "100.113.25.38";
          };
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      preliminarySelfsigned = false;
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
