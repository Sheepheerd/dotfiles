{ lib, config, ... }:
{
  options.solarsystem.profiles.reduced = lib.mkEnableOption "is this a reduced personal host";
  config = lib.mkIf config.solarsystem.profiles.reduced {
    solarsystem.modules = {
      bootloader = lib.mkDefault true;
      packages = lib.mkDefault true;
      general = lib.mkDefault true;
      home-manager = lib.mkDefault true;
      firewall = lib.mkDefault true;
      resolved = lib.mkDefault true;
      users = lib.mkDefault true;
      hardware = lib.mkDefault true;
      pipewire = lib.mkDefault true;
      network = lib.mkDefault true;
      time = lib.mkDefault true;
      programs = lib.mkDefault true;
      zsh = lib.mkDefault true;
      blueman = lib.mkDefault true;
      networkDevices = lib.mkDefault true;
      # keyboards = lib.mkDefault true;
      gnome-keyring = lib.mkDefault true;
      # # xdg-portal = lib.mkDefault true;
      distrobox = lib.mkDefault true;
      appimage = lib.mkDefault false;
      hyprland = lib.mkDefault true;
      # nvidia = if config.solarsystem.isNixos && !config.solarsystem.isLaptop then true else false;
      nvidia = false;
      amd = if config.solarsystem.isNixos && !config.solarsystem.isLaptop then true else false;
      tailscale = lib.mkDefault true;
      mullvad = lib.mkDefault true;
      server = {
        ssh = lib.mkDefault true;
      };
      school = lib.mkDefault true;
    };

  };

}
