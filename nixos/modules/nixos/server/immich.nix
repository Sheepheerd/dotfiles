{
  lib,
  config,
  globals,
  ...
}:
let
  servicePort = 3001;
  serviceUser = "immich";
  serviceName = "immich";
  # serviceDomain = config.repo.secrets.common.services.domains.${serviceName};
  serviceDomain = "100.113.25.38";
in
{
  options.solarsystem.modules.server.${serviceName} =
    lib.mkEnableOption "enable ${serviceName} on server";
  config = lib.mkIf config.solarsystem.modules.server.${serviceName} {

    users.users.${serviceUser} = {
      extraGroups = [
        "video"
        "render"
        "users"
      ];
    };

    services.${serviceName} = {
      enable = true;
      host = "0.0.0.0";
      port = servicePort;
      openFirewall = true;
      mediaLocation = "/mnt/one-t-ssd/immich-app"; # dataDir
      environment = {
        IMMICH_MACHINE_LEARNING_URL = lib.mkForce "http://localhost:3003";
      };
    };

    # networking.firewall.allowedTCPPorts = [ 3001 ];

    nginx = {
      virtualHosts = {
        "${serviceDomain}" = {
          listen = [
            {
              addr = serviceDomain;
              port = 3001;
            }
          ];
        };
      };
    };

  };

}
