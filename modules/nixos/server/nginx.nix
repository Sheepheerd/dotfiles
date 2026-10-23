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

  # Every vhost only answers LAN + tailnet clients unless it sets `tailnetOnly = false`
  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { config, ... }:
        {
          options.tailnetOnly = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Only allow LAN and tailnet clients to reach this vhost.";
          };
          config.extraConfig = lib.mkIf config.tailnetOnly ''
            allow 127.0.0.1;
            allow ::1;
            allow 192.168.0.0/24;
            allow 100.64.0.0/10;
            allow fd7a:115c:a1e0::/48;
            deny all;
          '';
        }
      )
    );
  };

  config = lib.mkIf config.solarsystem.modules.server.nginx {

    environment.systemPackages = with pkgs; [ lego ];
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    networking.firewall.allowedUDPPorts = [ 41641 ];
    # blocky DNS for LAN clients only; the tailnet reaches it through the trusted tailscale0
    networking.firewall.interfaces.enp4s0 = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };

    age.secrets.acme-api = {
      file = self + /secrets/server/acme.age;
      owner = "sheep";
      group = "users";
      mode = "0440";
    };

    age.secrets.blocky = {
      file = self + /secrets/server/blocky.age;
      owner = "root";
      group = "root";
      mode = "0444";
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
            sites = [ "${config.age.secrets.blocky.path}" ];
            adult = [
              "https://blocklistproject.github.io/Lists/porn.txt"
            ];
          };
          clientGroupsBlock = {
            default = [
              "ads"
              "adult"
              "sites"
            ];
          };
        };
        customDNS = {
          mapping = {
            "movies.heerd.dev" = serverIp;
            "nextcloud.heerd.dev" = serverIp;
            "radical.heerd.dev" = serverIp;
            "bank.heerd.dev" = serverIp;
            "bank-import.heerd.dev" = serverIp;
            "cars.heerd.dev" = serverIp;
            "track.heerd.dev" = serverIp;
            "dash.heerd.dev" = serverIp;
            "images.heerd.dev" = serverIp;
            "books.heerd.dev" = serverIp;
            "music.heerd.dev" = serverIp;
            "paperless.heerd.dev" = serverIp;
            # "deluge.heerd.dev" = serverIp;
            "joplin.heerd.dev" = serverIp;
            "notes.heerd.dev" = serverIp;
          };
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "shepard@heerd.dev";
        dnsProvider = "cloudflare";
        # Check propagation against public DNS; the system resolver is tailscale's
        # 100.100.100.100, which never sees the _acme-challenge TXT records
        dnsResolver = "1.1.1.1:53";
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

      # drop requests for unknown hostnames instead of serving whichever vhost sorts first
      virtualHosts."_" = {
        default = true;
        rejectSSL = true;
        locations."/".return = "444";
      };
    };
  };
}
