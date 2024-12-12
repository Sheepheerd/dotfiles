{

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/6cbcf132-63ad-4451-acd5-5a85291d6a41";
    fsType = "ext4";
    options = [ "nofail" ];

  };
  fileSystems."/mnt/movies" = {
    device = "10.147.17.9:/hdd/Plex/media";
    fsType = "nfs";

    options = [
      "x-systemd.idle-timeout=20"
    ]; # disconnects after 10 minutes (i.e. 600 seconds)
  };
}
