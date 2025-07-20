{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let

  serviceUser = "radicale";
  serviceGroup = serviceUser;
  cfg = config.solarsystem.modules.server.radicale;
in
{
  options.solarsystem.modules.server.radicale = lib.mkEnableOption "Enable radical service";

  config = lib.mkIf cfg {

    users = {
      groups.${serviceGroup} = { };
      users.${serviceUser} = {
        group = lib.mkForce serviceGroup;
        extraGroups = [
          "users"
        ];
        # isSystemUser = true;
      };
    };

    services.radicale = {
      enable = true;
      settings = {
        server = {
          hosts = [ "100.113.25.38:5232" ];
        };
        auth = {
          type = "none";
        };
        storage = {
          filesystem_folder = "/mnt/one-t-ssd/radicale/collections";
        };
      };
    };
    systemd.tmpfiles.rules = [ "d /mnt/one-t-ssd/radicale/collections 0750 radicale radicale -" ];
  };
}
