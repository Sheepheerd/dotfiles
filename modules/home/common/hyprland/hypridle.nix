{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.solarsystem.modules.hyprland;
in
{
  config = lib.mkIf cfg {
    services.hypridle = {
      enable = true;
      package = if config.solarsystem.isNixos then pkgs.hypridle else null;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = ''hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' '';
        };

        listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 150;
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -rd rgb:kbd_backlight";
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 330;
            on-timeout = ''hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })' '';
            on-resume = ''hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' '';
          }
        ]
        # Screen still blanks on a noSleep host, it just never suspends after.
        ++ lib.optionals (!config.solarsystem.noSleep) [
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];

      };
    };
  };
}
