{
  config,
  lib,
  self,
  inputs,
  pkgs,
  ...
}:

let

  serviceUser = "arr";
  serviceGroup = serviceUser;
  cfg = config.solarsystem.modules.server.arr;
in
{
  options.solarsystem.modules.server.arr = lib.mkEnableOption "Enable arr service";

  config = lib.mkIf cfg {

    # microvm.vms = {
    #   my-microvm = {
    #     config = {
    #
    #       microvm.shares = [
    #         {
    #           proto = "virtiofs";
    #           tag = "agenix";
    #           source = "/var/run/agenix.d/";
    #           mountPoint = "/var/run/agenix";
    #           readOnly = true;
    #         }
    #       ];
    #       microvm.hypervisor = "qemu";
    #       # Make VM reachable from host
    #       microvm.interfaces = [
    #         {
    #           # NAT interface with ports forwarded
    #           type = "user";
    #           id = "enp4s0";
    #           mac = "b4:2e:99:e9:97:33";
    #           # hostPort:guestPort
    #         }
    #       ];
    #       microvm.forwardPorts = [
    #         {
    #           from = "host";
    #           host.port = 8112;
    #           guest.port = 8112;
    #         }
    #         {
    #           from = "host";
    #           host.port = 2222;
    #           guest.port = 22;
    #         }
    #       ];
    #       imports = [
    #         # inputs.nixarr.nixosModules.default
    #       ];
    #       users.users.root.initialPassword = "root";
    #       networking.firewall.allowedTCPPorts = [
    #         8112
    #         22
    #         58846
    #       ];
    #       services = {
    #
    #         openssh = {
    #           enable = true;
    #           settings = {
    #             PermitRootLogin = "yes";
    #           };
    #         };
    #         mullvad-vpn.enable = true;
    #       };
    #
    #       services.resolved = {
    #         enable = true;
    #       };
    #       services.deluge = {
    #         enable = true;
    #         web.enable = true;
    #       };
    #       services.deluge.dataDir = "/var/lib/deluge";
    #     };
    #   };
    # };

    # age.secrets = {
    #   vpn-env-file = {
    #     file = self + /secrets/server/arr/vpn.age;
    #     symlink = false;
    #     path = "/var/run/agenix.d/vpn-env-file";
    #   };
    # };
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
        "prowlarr.heerd.dev" = {
          enableACME = true;
          forceSSL = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:9696";
              extraConfig = '''';
            };
          };
        };
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
