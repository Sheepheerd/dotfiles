{ lib, config, ... }:
{
  options.solarsystem.profiles.gaming = lib.mkEnableOption "is this a gaming host";
  config = lib.mkIf config.solarsystem.profiles.gaming {
    solarsystem.modules = {
      sunshine = lib.mkDefault true;
      steam = lib.mkDefault true;
      minecraft = lib.mkDefault true;
      dolphin = lib.mkDefault false;
    };

  };

}
