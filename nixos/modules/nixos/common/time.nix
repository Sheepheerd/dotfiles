{ lib, config, ... }:

let
  cfg = config.solarsystem.modules.time;
in
{
  options.solarsystem.modules.time = {
    enable = lib.mkEnableOption "Enable time and locale configuration";

    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "America/New_York";
      description = "The system time zone.";
    };

    hardwareClockInLocalTime = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether the hardware clock is set to local time.";
    };
  };

  config = lib.mkIf cfg.enable {
    time = {
      timeZone = cfg.timeZone;
      hardwareClockInLocalTime = cfg.hardwareClockInLocalTime;
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
