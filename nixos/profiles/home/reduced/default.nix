{ lib, config, ... }:
{
  options.solarsystem.profiles.reduced = lib.mkEnableOption "is this a reduced personal host";
  config = lib.mkIf config.solarsystem.profiles.reduced {
    solarsystem.modules = {
      packages = lib.mkDefault true;
      general = lib.mkDefault true;
      # ssh = lib.mkDefault true;
      # desktop = lib.mkDefault true;
      # env = lib.mkDefault true;
      direnv = lib.mkDefault true;
      eza = lib.mkDefault true;
      # git = lib.mkDefault true;
      fuzzel = lib.mkDefault true;
      zsh = lib.mkDefault true;
      firefox = lib.mkDefault true;
      gnome-keyring = lib.mkDefault true;
      dunst = lib.mkDefault true;
      ghostty = lib.mkDefault true;
      gtk = lib.mkDefault true;
      # orcaSlicer = lib.mkDefault true;
      tmux = lib.mkDefault true;
      waybar.enable = lib.mkDefault true;
      hyprland = lib.mkDefault true;
      nixvim = lib.mkDefault true;
    };
  };

}
