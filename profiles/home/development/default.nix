{ lib, config, ... }:
{
  options.solarsystem.profiles.development = lib.mkEnableOption "is this a development personal host";
  config = lib.mkIf config.solarsystem.profiles.development {
    solarsystem.modules = {
      general = lib.mkDefault true;
      packages = lib.mkDefault true;
      # ssh = lib.mkDefault true;
      # env = lib.mkDefault true;
      direnv = lib.mkDefault true;
      eza = lib.mkDefault true;
      git = lib.mkDefault true;
      zsh = lib.mkDefault true;
      gnome-keyring = lib.mkDefault true;
      tmux = lib.mkDefault true;
      nixvim = lib.mkDefault true;
    };
  };

}
