{ lib, config, ... }:
{
  options.solarsystem.profiles.darwin = lib.mkEnableOption "is this a darwin personal host";
  config = lib.mkIf config.solarsystem.profiles.darwin {
    solarsystem.modules = {
      packages = lib.mkDefault true;
      general = lib.mkDefault true;
      home-manager = lib.mkDefault true;
    };

  };

}
