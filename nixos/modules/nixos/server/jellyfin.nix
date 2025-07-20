{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let

  serviceUser = "jellyfin";
  serviceGroup = serviceUser;

  cfg = config.solarsystem.modules.server.jellyfin;
in
{
  options.solarsystem.modules.server.jellyfin = lib.mkEnableOption "Enable jellyfin server";

  config = mkIf cfg {

    users = {
      groups.${serviceGroup} = { };
      users.${serviceUser} = {
        group = lib.mkForce serviceGroup;
        extraGroups = [
          "video"
          "render"
          "users"
        ];
        isSystemUser = true;
      };
    };

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
    services.jellyfin = {
      enable = true;
      dataDir = "/mnt/two-t-hdd/jellyfin";
      user = serviceUser;
      # openFirewall = true;
      # port = 8096; Non configurable
    };
  };
}
