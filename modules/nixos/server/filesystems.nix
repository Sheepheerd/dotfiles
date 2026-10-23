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

    # NFS for LAN clients only
    networking.firewall.interfaces.enp4s0 = {
      allowedTCPPorts = [ 2049 ];
      allowedUDPPorts = [ 2049 ];
    };

  };
}
