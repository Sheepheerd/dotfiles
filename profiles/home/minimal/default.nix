{ lib, config, ... }:
{
  options.solarsystem.profiles.minimal = lib.mkEnableOption "is this a reduced personal host";
  config = lib.mkIf config.solarsystem.profiles.minimal {
    solarsystem.modules = {
      general = lib.mkDefault true;
      # ssh = lib.mkDefault true;
      # desktop = lib.mkDefault true;
      # env = lib.mkDefault true;
      eza = lib.mkDefault true;
      # git = lib.mkDefault true;
      zsh = lib.mkDefault true;
      tmux = lib.mkDefault true;
      # nixvim = lib.mkDefault true;
    };
  };

}
