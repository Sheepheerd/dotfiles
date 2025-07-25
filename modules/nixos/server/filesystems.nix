{ lib, config, ... }:

let
  cfg = config.solarsystem.modules.filesystems;
in
{
  options.solarsystem.modules.filesystems = lib.mkEnableOption "Enable custom filesystem mounts";

  config = lib.mkIf cfg {
    fileSystems."/mnt/two-t-hdd" = {
      device = "/dev/disk/by-uuid/a2055d3c-e51e-4529-b90d-e81650d27f24";
      fsType = "ext4";
      options = [ "bind" ];
    };

    fileSystems."/mnt/one-t-ssd" = {
      device = "/dev/disk/by-uuid/a2055d3c-e51e-4529-b90d-e81650d27f24";
      fsType = "ext4";
      options = [ "bind" ];
    };
  };
}
