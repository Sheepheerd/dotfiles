{ lib, config, ... }:

let
  cfg = config.solarsystem.modules.filesystems;
in
{
  options.solarsystem.modules.filesystems = lib.mkEnableOption "Enable custom filesystem mounts";

  config = lib.mkIf cfg {

    services.nfs.server = {
      enable = true;
      exports = ''
        /mnt/two-t-hdd/jellyfin_media/Movies 192.168.0.219(rw,sync,all_squash,anonuid=988,anongid=169)
      '';

    };

    networking.firewall.allowedTCPPorts = [ 2049 ];
    networking.firewall.allowedUDPPorts = [ 2049 ];

  };
}
