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
      # opengl.driSupport32Bit = true is replaced with graphics.enable32Bit and hence redundant
      # graphics = {
      #   enable = true;
      #   enable32Bit = true;
      # };

      keyboard.qmk.enable = true;

      bluetooth = lib.mkIf config.solarsystem.hasBluetooth {
        enable = true;
        package = pkgs.stable.bluez;
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
