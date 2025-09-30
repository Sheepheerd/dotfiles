{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.solarsystem.modules.fuzzel;
in
{
  options.solarsystem.modules.fuzzel = lib.mkEnableOption "Enable fuzzel launcher and related scripts";

  config = lib.mkIf cfg {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "${pkgs.zsh}/bin/zsh";
          layer = "overlay";
        };
        colors = {
          background = "282a36dd";
          text = "f8f8f2ff";
          match = "8be9fdff";
          selection-match = "8be9fdff";
          selection = "44475add";
          selection-text = "f8f8f2ff";
          border = "bd93f9ff";
        };
      };
    };

    home.file.".scripts/fuzzel-powermenu.sh" = {
      text = ''
        #!/usr/bin/env bash

        SELECTION="$(printf "1 - Lock\n2 - Suspend\n3 - Log out\n4 - Reboot\n5 - Reboot to UEFI\n6 - Shutdown" | fuzzel --dmenu -l 7 -p "Power Menu: ")"

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
