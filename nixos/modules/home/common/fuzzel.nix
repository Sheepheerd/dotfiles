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

    home.file.".scripts/fuzzel-calculator.sh" = {
      text = ''
        #!/usr/bin/env sh

        # Define the variable that holds the last result
        LAST=""

        # Don't stop until the user hits escape or clicks off of fuzzel
        while true; do
            # Add a space on the first run
            [ -z "$LAST" ] && SPACE=" "

            # Get user input
            NEXT="$(fuzzel -l 0 --dmenu -p "$LAST$SPACE")"

            # Quit if empty
            [ -z "$NEXT" ] && exit 1

            # Copy and exit if y is entered
            [ "$NEXT" = "y" ] && wl-copy "$LAST" && exit 0

            # Pipe the expression into bc and strip off trailing zeroes and decimal point
            LAST="$(echo "$LAST$NEXT" | bc -l | sed 's/\.\([0-9]*[1-9]\)0*\./\.\1/;s/\.$//')"
        done
      '';
      executable = true;
    };
  };
}
