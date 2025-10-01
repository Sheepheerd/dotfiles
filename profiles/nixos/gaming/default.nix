{ lib, config, ... }:
{
  options.solarsystem.profiles.gaming = lib.mkEnableOption "is this a gaming host";
  config = lib.mkIf config.solarsystem.profiles.gaming {
    solarsystem.modules = {
      modules.sunshine = lib.mkDefault true;
      modules.steam = lib.mkDefault true;
      modules.minecraft = lib.mkDefault true;
      modules.dolphin = lib.mkDefault true;
    };

  };

}
