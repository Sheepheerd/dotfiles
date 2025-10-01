{ lib, config, ... }:
{
  options.solarsystem.profiles.gaming = lib.mkEnableOption "is this a gaming host";
  config = lib.mkIf config.solarsystem.profiles.gaming {
    solarsystem.modules = {
    };

  };

}
