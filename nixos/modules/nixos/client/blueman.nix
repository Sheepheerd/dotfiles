{ lib, config, ... }:
{
  options.solarsystem.modules.blueman = lib.mkEnableOption "blueman config";
  config = lib.mkIf config.solarsystem.modules.blueman {
    services.blueman.enable = true;
  };
}
