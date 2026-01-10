{ lib, config, ... }:
{
  options.solarsystem.profiles.gaming = lib.mkEnableOption "is this a gaming host";
  config = lib.mkIf config.solarsystem.profiles.gaming {
    solarsystem.modules = {
      packages = lib.mkDefault true;
      general = lib.mkDefault true;
      # ssh = lib.mkDefault true;
      desktop = lib.mkDefault true;
      # env = lib.mkDefault true;
      direnv = lib.mkDefault true;
      eza = lib.mkDefault true;
      git = lib.mkDefault true;
      fuzzel = lib.mkDefault true;
      zsh = lib.mkDefault true;
      programs = lib.mkDefault true;
      gnome-keyring = lib.mkDefault true;
      ghostty = lib.mkDefault true;
      gtk = lib.mkDefault true;
      tmux = lib.mkDefault true;
      waybar.enable = lib.mkDefault true;
      hyprland = lib.mkDefault true;
    };

  };

}
