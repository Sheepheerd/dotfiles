{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.solarsystem.modules.walker;
in
{
  options.solarsystem.modules.walker = lib.mkEnableOption "Enable walker launcher and related scripts";

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      walker
      elephant
    ];

    # walker 2.x holds no providers of its own -- it queries the elephant
    # backend over a socket. Without this running the launcher opens empty.
    systemd.user.services.elephant = {
      Unit = {
        Description = "Elephant data provider backend for walker";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.elephant}/bin/elephant";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    # Launching walker cold on every keypress pays for GTK init each time.
    # Kept resident as a GApplication service, the keybind's `walker` only
    # asks the running instance over D-Bus to show its window.
    systemd.user.services.walker = {
      Unit = {
        Description = "Walker launcher kept resident for instant open";
        PartOf = [ "graphical-session.target" ];
        After = [
          "graphical-session.target"
          "elephant.service"
        ];
        Wants = [ "elephant.service" ];
      };
      Service = {
        ExecStart = "${pkgs.walker}/bin/walker --gapplication-service";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    home.file.".scripts/walker-powermenu.sh" = {
      text = ''
        #!/usr/bin/env bash

        # A --dmenu call that reaches the resident walker over D-Bus segfaults
        # it and hands back nothing, so every entry here silently did nothing
        # and took the launcher down with it. Pointing this one call at a dead
        # bus makes GApplication fall back to a private primary instance: the
        # menu answers here, and the resident launcher stays up.
        dmenu() {
          DBUS_SESSION_BUS_ADDRESS=unix:path=/nonexistent walker --dmenu "$@"
        }

        SELECTION="$(printf "1 - Lock\n2 - Suspend\n3 - Log out\n4 - Reboot\n5 - Reboot to UEFI\n6 - Shutdown" | dmenu -p "Power Menu: ")"

        # The menu runs with no terminal attached, so a selection that lands on
        # the wrong entry leaves no trace. Record what came back before acting
        # on it: journalctl -t powermenu.
        logger -t powermenu "selection=[$SELECTION]"

        # Matched on the label alone, and exactly. The patterns used to be
        # trailing globs, which meant an unexpected answer -- an empty string,
        # a truncated line -- could still fall into a branch that tears the
        # session down.
        case "''${SELECTION##* - }" in
          "Lock")
            hyprlock;;
          "Suspend")
            systemctl suspend;;
          "Log out")
            # SIGKILLing the user meant killing systemd --user along with the
            # compositor, which leaves the session half-torn-down and the last
            # frame stuck on screen. uwsm stops the compositor the way the
            # session was started.
            uwsm stop || loginctl terminate-user "$USER";;
          "Reboot")
            systemctl reboot;;
          "Reboot to UEFI")
            systemctl reboot --firmware-setup;;
          "Shutdown")
            systemctl poweroff;;
          *)
            logger -t powermenu "no action for selection=[$SELECTION]";;
        esac
      '';
      executable = true;
    };

  };
}
