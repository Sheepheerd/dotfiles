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
      # pipewire = lib.mkDefault true;
      network = lib.mkDefault true;
      time = lib.mkDefault true;
      programs = lib.mkDefault true;
      zsh = lib.mkDefault true;
      # blueman = lib.mkDefault true;
      networkDevices = lib.mkDefault true;
      # keyboards = lib.mkDefault true;
      gnome-keyring = lib.mkDefault true;
      # # xdg-portal = lib.mkDefault true;
      # distrobox = lib.mkDefault true;
      # appimage = lib.mkDefault true;
      # hyprland = lib.mkDefault true;
      nvidia = if config.solarsystem.isNixos && !config.solarsystem.isLaptop then true else false;
      tailscaleServer = lib.mkDefault true;
      server = {
        ssh = lib.mkDefault true;
        nginx = lib.mkDefault true;
        firefly-iii = lib.mkDefault true;
        immich = lib.mkDefault true;
      };
      # filesystems = lib.mkDefault true;
      ageServer = lib.mkDefault true;
    };

  };

}
