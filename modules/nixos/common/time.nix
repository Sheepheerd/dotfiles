{ lib, config, ... }:
{
  options.solarsystem.modules.time = lib.mkEnableOption "time config";
  config = lib.mkIf config.solarsystem.modules.time {
    time = {
      timeZone = "America/New_York";
      # hardwareClockInLocalTime = true;
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "de_AT.UTF-8";
        LC_IDENTIFICATION = "de_AT.UTF-8";
        LC_MEASUREMENT = "de_AT.UTF-8";
        LC_MONETARY = "de_AT.UTF-8";
        LC_NAME = "de_AT.UTF-8";
        LC_NUMERIC = "de_AT.UTF-8";
        LC_PAPER = "de_AT.UTF-8";
        LC_TELEPHONE = "de_AT.UTF-8";
        LC_TIME = "de_AT.UTF-8";
      };
    };
  };
}
