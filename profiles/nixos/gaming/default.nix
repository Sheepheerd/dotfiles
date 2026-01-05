{ lib, config, ... }:
{
  options.solarsystem.profiles.gaming = lib.mkEnableOption "is this a gaming host";
  config = lib.mkIf config.solarsystem.profiles.gaming {
    solarsystem.modules = {
<<<<<<< HEAD
      jovian = lib.mkDefault true;

      bootloader = lib.mkDefault true;
      packages = lib.mkDefault true;
      general = lib.mkDefault true;
      home-manager = lib.mkDefault true;
      firewall = lib.mkDefault true;
      resolved = lib.mkDefault false;
      users = lib.mkDefault true;
      hardware = lib.mkDefault true;
      pipewire = lib.mkDefault true;
      udev = lib.mkDefault true;
      network = lib.mkDefault true;
      time = lib.mkDefault true;
      programs = lib.mkDefault true;
      zsh = lib.mkDefault true;
      blueman = lib.mkDefault true;
      networkDevices = lib.mkDefault true;
      gnome-keyring = lib.mkDefault true;
      virt = lib.mkDefault true;
      appimage = lib.mkDefault false;
      hyprland = lib.mkDefault false;
      nvidia = lib.mkDefault false;
      amd = lib.mkDefault false;
      tailscale = lib.mkDefault true;
      mullvad = lib.mkDefault false;
      server = {
        ssh = lib.mkDefault true;
      };
      school = lib.mkDefault false;
      stylix = lib.mkDefault true;

      # sunshine = lib.mkDefault true;
      # steam = lib.mkDefault true;
      # minecraft = lib.mkDefault true;
      # dolphin = lib.mkDefault false;
    };

  };

}
