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

    home.file.".scripts/walker-powermenu.sh" = {
      text = ''
        #!/usr/bin/env bash

        SELECTION="$(printf "1 - Lock\n2 - Suspend\n3 - Log out\n4 - Reboot\n5 - Reboot to UEFI\n6 - Shutdown" | walker --dmenu -p "Power Menu: ")"

        case $SELECTION in
          *"Lock")
            hyprlock;;
          *"Suspend")
            systemctl suspend;;
          *"Log out")
            pkill -KILL -u "$USER";;
          *"Reboot")
            systemctl reboot;;
          *"Reboot to UEFI")
            systemctl reboot --firmware-setup;;
          *"Shutdown")
            systemctl poweroff;;
        esac
      '';
      executable = true;
    };

  };
}
