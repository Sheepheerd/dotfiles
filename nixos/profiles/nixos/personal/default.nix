{ lib, config, ... }:
{
  options.solarsystem.profiles.personal = lib.mkEnableOption "is this a personal host";
  config = lib.mkIf config.solarsystem.profiles.personal {
    solarsystem.modules = {
      # packages = lib.mkDefault true;
      # general = lib.mkDefault true;
      # home-manager = lib.mkDefault true;
      # users = lib.mkDefault true;
      # # hardware = lib.mkDefault true;
      # pipewire = lib.mkDefault true;
      # networking = lib.mkDefault true;
      # time = lib.mkDefault true;
      # programs = lib.mkDefault true;
      # zsh = lib.mkDefault true;
      # blueman = lib.mkDefault true;
      # networkDevices = lib.mkDefault true;
      # # keyboards = lib.mkDefault true;
      # gnome-keyring = lib.mkDefault true;
      # distrobox = lib.mkDefault true;
      # appimage = lib.mkDefault true;

      # server = {
      #   ssh = lib.mkDefault true;
      # };
    };

  };

}
