{ lib, config, ... }:
{
  options.solarsystem.profiles.server = lib.mkEnableOption "is this a server personal host";
  config = lib.mkIf config.solarsystem.profiles.server {
    solarsystem.modules = {
      general = lib.mkDefault true;
      # ssh = lib.mkDefault true;
      # env = lib.mkDefault true;
      packages = lib.mkDefault true;
      ghostty = lib.mkDefault true;
      programs = lib.mkDefault true;
      direnv = lib.mkDefault true;
      eza = lib.mkDefault true;
      git = lib.mkDefault true;
      fuzzel = lib.mkDefault true;
      zsh = lib.mkDefault true;
      tmux = lib.mkDefault true;
      # nixvim = lib.mkDefault true;
    };
  };

}
