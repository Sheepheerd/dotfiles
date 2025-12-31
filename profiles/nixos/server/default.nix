{ lib, config, ... }:
{
  options.solarsystem.profiles.server = lib.mkEnableOption "is this a server personal host";
  config = lib.mkIf config.solarsystem.profiles.server {
    solarsystem.modules = {
      bootloader = lib.mkDefault true;
      packages = lib.mkDefault true;
      general = lib.mkDefault true;
      home-manager = lib.mkDefault true;
      users = lib.mkDefault true;
      hardware = lib.mkDefault true;
      network = lib.mkDefault true;
      resolved = lib.mkDefault false;
      time = lib.mkDefault true;
      programs = lib.mkDefault true;
      zsh = lib.mkDefault true;
      networkDevices = lib.mkDefault true;
      gnome-keyring = lib.mkDefault true;
      nvidia = lib.mkDefault false;
      tailscaleServer = lib.mkDefault true;
      server = {
        ssh = lib.mkDefault true;
        nginx = lib.mkDefault true;
        firefly-iii = lib.mkDefault true;
        immich = lib.mkDefault true;
        paperless = lib.mkDefault true;
        jellyfin = lib.mkDefault true;
        arr = lib.mkDefault true;
        radicale = lib.mkDefault true;
        nextcloud = lib.mkDefault true;
        calibre = lib.mkDefault true;
        navidrome = lib.mkDefault true;
      };
      filesystems = lib.mkDefault true;

      amd = lib.mkDefault false;
      ageServer = lib.mkDefault true;
    };

  };

}
