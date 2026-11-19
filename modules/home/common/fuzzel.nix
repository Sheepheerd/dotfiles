{
  lib,
  config,
  ...
}:

let
  cfg = config.solarsystem.modules.fuzzel;

  # Same source of truth as hyprlock: the sddm greeter's theme.conf, which is
  # itself lifted from the quickshell bar. Plain `key=value` lines plus comments.
  palette = lib.pipe ../../nixos/client/sddm/theme/theme.conf [
    builtins.readFile
    (lib.splitString "\n")
    (lib.filter (line: lib.hasInfix "=" line && !lib.hasPrefix "#" line))
    (map (
      line:
      let
        parts = lib.splitString "=" line;
      in
      lib.nameValuePair (lib.head parts) (lib.concatStringsSep "=" (lib.tail parts))
    ))
    lib.listToAttrs
  ];

  # fuzzel wants rrggbbaa with no leading `#`.
  rgba = hex: alpha: "${lib.removePrefix "#" hex}${alpha}";
in
{
  options.solarsystem.modules.fuzzel = lib.mkEnableOption "Enable fuzzel launcher and related scripts";

  config = lib.mkIf cfg {
    # fuzzel is a single native Wayland binary: no GTK, no daemon, no backend
    # service. Cold start is a few milliseconds, so every keypress just runs it.
    programs.fuzzel = {
      enable = true;
      # mkForce: stylix's fuzzel target would otherwise paint it rose-pine,
      # which matches nothing else on the desktop.
      settings = lib.mkForce {
        main = {
          font = "${palette.font}:size=12";
          prompt = "\"❯ \"";
          terminal = "ghostty -e";
          layer = "overlay";
          width = 40;
          lines = 10;
          horizontal-pad = 20;
          vertical-pad = 14;
          inner-pad = 8;
          line-height = 22;
          icons-enabled = true;
          # Launched apps get their own systemd scope under the uwsm session
          # instead of living inside fuzzel's process.
          launch-prefix = "uwsm app --";
        };
        colors = {
          background = rgba palette.background "f2";
          text = rgba palette.foreground "ff";
          prompt = rgba palette.subdued "ff";
          placeholder = rgba palette.subdued "ff";
          input = rgba palette.foreground "ff";
          match = rgba palette.foreground "ff";
          selection = rgba palette.hover "ff";
          selection-text = rgba palette.foreground "ff";
          selection-match = rgba palette.foreground "ff";
          counter = rgba palette.subdued "ff";
          border = rgba palette.border "ff";
        };
        border = {
          width = 2;
          radius = 16;
        };
      };
    };

    home.file.".scripts/powermenu.sh" = {
      text = ''
        #!/usr/bin/env bash

        SELECTION="$(printf "Lock\nSuspend\nLog out\nReboot\nReboot to UEFI\nShutdown" \
          | fuzzel --dmenu --lines 6 --width 22 --prompt "⏻  ")"

        # The menu runs with no terminal attached, so a selection that lands on
        # the wrong entry leaves no trace. Record what came back before acting
        # on it: journalctl -t powermenu.
        logger -t powermenu "selection=[$SELECTION]"

        # Matched exactly, so an unexpected answer -- an empty string, a
        # truncated line -- can never fall into a branch that tears the
        # session down.
        case "$SELECTION" in
          "Lock")
            hyprlock;;
          "Suspend")
            systemctl suspend;;
          "Log out")
            # uwsm stops the compositor the way the session was started. A
            # session launched without uwsm makes `uwsm stop` report "not
            # running" and still exit 0, so ask first and let Hyprland exit
            # itself otherwise.
            if uwsm check is-active >/dev/null 2>&1; then
              uwsm stop
            else
              hyprctl dispatch 'hl.dsp.exit()'
            fi;;
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
