{
  pkgs,
  config,
  lib,
  ...
}:
{

  options.solarsystem = {
    modules.hardware = lib.mkEnableOption "hardware config";
    hasBluetooth = lib.mkEnableOption "bluetooth availability";
  };
  config = lib.mkIf config.solarsystem.modules.hardware {
    hardware = {
      keyboard.qmk.enable = true;

      bluetooth = lib.mkIf config.solarsystem.hasBluetooth {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
          };
        };
      };
    };

  };
}
