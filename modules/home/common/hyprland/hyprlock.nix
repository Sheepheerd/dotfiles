{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.solarsystem.modules.hyprland;

  # The sddm greeter's theme.conf is the source of truth for the palette and
  # font, so the lock screen and the login screen cannot drift apart. It is
  # plain `key=value` lines plus comments.
  palette = lib.pipe ../../../nixos/client/sddm/theme/theme.conf [
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

  # hyprlock wants rgb(rrggbb) for colour options, and `#` starts a comment,
  # so inside pango markup it has to be escaped as `##`.
  rgb = hex: "rgb(${lib.removePrefix "#" hex})";
  markup = hex: "##${lib.removePrefix "#" hex}";
in
{
  config = lib.mkIf cfg {
    programs.hyprlock = {
      enable = true;
      package = if config.solarsystem.isNixos then pkgs.hyprlock else null;

      sourceFirst = true;

      # Laid out like the greeter's Main.qml: a clock, the date under it and a
      # pill-shaped password field, all on one centred column.
      extraConfig = with palette; ''
        general {
          disable_loading_bar = true
          hide_cursor = true
        }

        background {
          monitor =
          color = ${rgb background}
        }

        label {
          monitor =
          text = <span weight="light" letter_spacing="-2048">$TIME</span>
          color = ${rgb foreground}
          font_size = 96
          font_family = ${font}
          position = 0, 110
          halign = center
          valign = center
        }

        label {
          monitor =
          text = cmd[update:60000] echo "<span letter_spacing=\"3072\">$(date +'%A, %-d %B' | tr '[:upper:]' '[:lower:]')</span>"
          color = ${rgb subdued}
          font_size = 14
          font_family = ${font}
          position = 0, 35
          halign = center
          valign = center
        }

        input-field {
          monitor =
          size = 300, 44
          rounding = -1
          outline_thickness = 1
          dots_size = 0.2
          dots_spacing = 0.4
          dots_center = true
          outer_color = ${rgb border}
          inner_color = ${rgb surface}
          font_color = ${rgb foreground}
          font_family = ${font}
          fade_on_empty = false
          placeholder_text = <span foreground="${markup subdued}">password</span>
          hide_input = false
          check_color = ${rgb hover}
          fail_color = ${rgb error}
          fail_text = <span foreground="${markup error}">Incorrect password</span>
          capslock_color = ${rgb hover}
          position = 0, -90
          halign = center
          valign = center
        }
      '';
    };
  };
}
