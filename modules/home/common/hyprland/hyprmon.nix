{
  lib,
  config,
  pkgs,
  ...
}:

let
  hyprlandEnabled = config.solarsystem.modules.hyprland;
  # Declared in config.nix; everything else is "the second monitor".
  primary = config.wayland.windowManager.hyprland.settings.monitor.output;

  # TUI for the second monitor. Writes monitors-local.lua, which hyprland.lua
  # loads in place of the Nix default, so no rebuild is needed.
  hyprmon = pkgs.writeShellApplication {
    name = "hyprmon";
    runtimeInputs = with pkgs; [
      gum
      jq
    ];
    text = ''
      primary=${lib.escapeShellArg primary}
      file="''${XDG_CONFIG_HOME:-$HOME/.config}/hypr/monitors-local.lua"

      monitors=$(hyprctl monitors all -j)
      mapfile -t outputs < <(jq -r --arg p "$primary" '.[] | select(.name != $p) | .name' <<<"$monitors")
      if ((''${#outputs[@]} == 0)); then
        gum log --level error "No monitor besides $primary is connected"
        exit 1
      elif ((''${#outputs[@]} == 1)); then
        output=''${outputs[0]}
      else
        output=$(gum choose --header "Monitor" "''${outputs[@]}")
      fi

      layout=$(gum choose --header "$output" \
        "Left of $primary" "Right of $primary" "Above $primary" "Below $primary" \
        "Mirror $primary" "Disable" "Reset to Nix default")

      pick_mode() {
        local modes
        mapfile -t modes < <(jq -r --arg o "$output" \
          '.[] | select(.name == $o) | .availableModes[] | sub("Hz$"; "")' <<<"$monitors")
        gum choose --header "Mode" "preferred" "''${modes[@]}"
      }

      pick_scale() {
        local scale
        scale=$(gum choose --header "Scale" 1 1.25 1.5 1.6 2 auto custom)
        if [[ $scale == custom ]]; then
          scale=$(gum input --header "Scale" --placeholder "1.333")
        fi
        [[ $scale == auto ]] && scale='"auto"'
        echo "$scale"
      }

      case $layout in
        Left*) position=auto-left ;;
        Right*) position=auto-right ;;
        Above*) position=auto-up ;;
        Below*) position=auto-down ;;
      esac

      case $layout in
        Reset*)
          content=""
          ;;
        Disable)
          content="hl.monitor({ output = \"$output\", disabled = true })"
          ;;
        Mirror*)
          content="hl.monitor({ output = \"$output\", mode = \"preferred\", position = \"auto\", scale = $(pick_scale), mirror = \"$primary\" })"
          ;;
        *)
          content="hl.monitor({ output = \"$output\", mode = \"$(pick_mode)\", position = \"$position\", scale = $(pick_scale) })"
          ;;
      esac

      backup=$(mktemp)
      trap 'rm -f "$backup"' EXIT
      had_file=false
      if [[ -f $file ]]; then
        cp "$file" "$backup"
        had_file=true
      fi

      if [[ -z $content ]]; then
        rm -f "$file"
      else
        printf -- '-- Written by hyprmon; delete to fall back to the Nix default.\n%s\n' "$content" >"$file"
      fi
      hyprctl reload >/dev/null

      # A bad mode can leave the screen dark, so anything but an explicit
      # "yes" within the timeout puts the old file back.
      if gum confirm --default=false --timeout=15s "Keep this layout?"; then
        gum log --level info "Saved $file"
      else
        if $had_file; then cp "$backup" "$file"; else rm -f "$file"; fi
        hyprctl reload >/dev/null
        gum log --level warn "Reverted"
      fi
    '';
  };
in
{
  config = lib.mkIf hyprlandEnabled {
    home.packages = [ hyprmon ];
  };
}
