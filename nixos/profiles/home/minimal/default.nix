{ lib, config, ... }:
{
  options.solarsystem.profiles.minimal = lib.mkEnableOption "is this a personal host";
  config = lib.mkIf config.solarsystem.profiles.minimal {
    solarsystem.modules = {
      general = lib.mkDefault true;
      # sops = lib.mkDefault true;
      # kitty = lib.mkDefault true;
      # zsh = lib.mkDefault true;
      # git = lib.mkDefault true;
    };
  };

}
