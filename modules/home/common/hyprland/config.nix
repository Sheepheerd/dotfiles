{
  lib,
  config,
  pkgs,
  ...
}:

let
  isLaptop = config.solarsystem.isLaptop;
  hyprlandEnabled = config.solarsystem.modules.hyprland;
  browser = "firefox";
  terminal = "ghostty";
  file = "thunar";

  # Backlight first, then hyprsunset gamma below the panel's floor (Asahi's 0 isn't off).
  brightness = pkgs.writeShellScript "brightness" ''
    bctl=${pkgs.brightnessctl}/bin/brightnessctl
    state="''${XDG_RUNTIME_DIR:-/tmp}/brightness-gamma"
    min_gamma=20
    gamma=$(cat "$state" 2>/dev/null || echo 100)
    set_gamma() { echo "$1" > "$state"; hyprctl hyprsunset gamma "$1" >/dev/null; }

    case "$1" in
      up)
        if [ "$gamma" -lt 100 ]; then
          set_gamma $(( gamma + 10 > 100 ? 100 : gamma + 10 ))
        else
          $bctl -q set 1%+
        fi ;;
      down)
        if [ "$($bctl get)" -gt 0 ]; then
          $bctl -q set 1%-
        else
          set_gamma $(( gamma - 10 < min_gamma ? min_gamma : gamma - 10 ))
        fi ;;
      max) set_gamma 100; $bctl -q set 100% ;;
      min) $bctl -q set 0 ;;
    esac
  '';

  monitor =
    if isLaptop then
      {
        primary = {
          output = "DP-1";
          mode = "1920x1080@144";
          position = "0x0";
          scale = 1;
        };
        secondary = {
          output = "eDP-1";
          mode = "2560x1600@60.00Hz";
          position = "auto";
          scale = 1.33;
          mirror = "DP-1";
        };

        # { output = "eDP-1"; mode = "preferred"; position = "auto"; scale = 1.6; }
        # { output = "DP-1"; mode = "1920x1080@60"; position = "0x0"; scale = 1; }
      }
    else
      {
        primary = {
          output = "DP-3";
          mode = "1920x1080@144";
          position = "0x0";
          scale = 1;
        };
        # 60 rather than the panel's 75: fewer competing vblanks against DP-3's 144.
        # comment out if using as standalone
        secondary = {
          output = "HDMI-A-1";
          mode = "1920x1080@75";
          position = "-1920x0";
          scale = 1;
        };
      };

  # Second-monitor default. Copied over monitors-local.lua on every rebuild
  # unless hyprmon wrote that file (see home.activation below).
  monitorsDefault = ''
    -- Nix default, rewritten on every rebuild. Run hyprmon to override.
    hl.monitor(${lib.generators.toLua { } monitor.secondary})
  '';

  # hl.curve(name, { type = "bezier", points = { {x0, y0}, {x1, y1} } })
  bezier = name: x0: y0: x1: y1: {
    _args = [
      name
      {
        type = "bezier";
        points = [
          [
            x0
            y0
          ]
          [
            x1
            y1
          ]
        ];
      }
    ];
  };

  animation =
    leaf: speed: curve: style:
    {
      inherit leaf speed;
      enabled = true;
      bezier = curve;
    }
    // lib.optionalAttrs (style != null) { inherit style; };
in
{
  config = lib.mkIf hyprlandEnabled {
    xdg.configFile."hypr/monitors-default.lua".text = monitorsDefault;

    home.activation.hyprMonitorsLocal = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      file=${lib.escapeShellArg "${config.xdg.configHome}/hypr/monitors-local.lua"}
      if ! head -n1 "$file" 2>/dev/null | grep -q '^-- Written by hyprmon'; then
        run install -Dm644 ${pkgs.writeText "monitors-default.lua" monitorsDefault} "$file"
      fi
    '';

    wayland.windowManager.hyprland = {
      enable = true;

      # Each attribute renders as an hl.<name>(...) call in hyprland.lua.
      settings = {
        monitor = monitor.primary;

        config = {
          input = {
            kb_layout = "us";
            kb_options = "shift:both_capslock,caps:ctrl_modifier";
            numlock_by_default = true;
            repeat_delay = 300;
            follow_mouse = 1;
            sensitivity = 0;
            touchpad = {
              disable_while_typing = true;
              scroll_factor = 0.3;
              natural_scroll = true;
            };

            force_no_accel = false;
            accel_profile = "flat";
          };

          general = {
            layout = "dwindle";
            gaps_in = 5;
            gaps_out = 5;
            border_size = 2;

            col = {
              active_border = "rgba(FFFFFF50)";
              inactive_border = "rgba(382D2Eff)";
            };
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            mouse_move_enables_dpms = true;
            # vfr = true;
            vrr = 0;
            animate_manual_resizes = true;
            mouse_move_focuses_monitor = true;
            enable_swallow = true;
          };

          dwindle = {
            # pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true; # you probably want this
          };

          decoration = {
            rounding = 6;

            active_opacity = 1.0;
            inactive_opacity = 0.8;

            blur = {
              enabled = false;
              size = 6;
              passes = 3;
              new_optimizations = true;
              xray = true;
              ignore_opacity = true;
            };
          };

          xwayland = {
            force_zero_scaling = true;
          };

          animations = {
            enabled = false;
          };
        };

        # Flat is right for a desktop mouse but makes a trackpad feel dead:
        # macOS accelerates trackpad motion, so slow movements stay precise
        # and quick flicks cross the screen. Only matches the MacBook's
        # built-in trackpad, so other hosts are untouched.
        device = [
          {
            name = "apple-spi-trackpad";
            accel_profile = "adaptive";
            scroll_factor = 0.2;

            sensitivity = -0.2;
          }
        ];

        gesture = [
          {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          }
        ];

        curve = [
          (bezier "wind" 0.05 0.9 0.1 1.05)
          (bezier "winIn" 0.1 1 0.1 1)
          (bezier "winOut" 0.3 (-0.3) 0 1)
          (bezier "liner" 1 1 1 1)
        ];

        animation = [
          (animation "windows" 6 "wind" "popin")
          (animation "windowsIn" 6 "winIn" "popin")
          (animation "windowsOut" 5 "winOut" "popin")
          (animation "windowsMove" 5 "wind" "popin")
          (animation "border" 1 "liner" null)
          (animation "borderangle" 30 "liner" "loop")
          (animation "fade" 10 "default" null)
          (animation "workspaces" 5 "wind" null)
        ];
      };

      extraConfig = ''
        local terminal = "${terminal}"
        local browser = "${browser}"
        local file = "${file}"

        hl.env("PATH", os.getenv("PATH") .. ":" .. os.getenv("HOME") .. "/.nix-profile/bin")

        -- Second monitor: monitors-local.lua next to this file is not managed
        -- by Nix, so it can be edited live (saved changes auto-reload). If it
        -- doesn't exist, fall back to the default below.
        local hypr_dir = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/hypr"
        local local_monitors = io.open(hypr_dir .. "/monitors-local.lua", "r")
        if local_monitors then
          local_monitors:close()
          require("monitors-local")
        else
          require("monitors-default")
        end

        -- Autostart
        hl.on("hyprland.start", function()
          hl.exec_cmd("dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
          hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

          hl.exec_cmd("${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1")
          hl.exec_cmd("swww-daemon")

          hl.exec_cmd("wl-clip-persist --clipboard both")
          hl.exec_cmd("wl-paste --watch cliphist store")
          hl.exec_cmd("${pkgs.nix}/etc/profile.d/nix-daemon.sh")
          hl.exec_cmd("hyprctl setcursor Dracula-cursors 24")
          hl.exec_cmd(terminal .. " --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false")

          -- Audio
          hl.exec_cmd("bash -c pavucontrol & sleep 1 && pkill pavucontrol", { workspace = "3 silent" })
          hl.exec_cmd("amixer set Master 1+ toggle")

          hl.exec_cmd(browser, { workspace = "2 silent" })
          hl.exec_cmd(terminal, { workspace = "1 silent" })
        end)

        -- Keybinds
        local exec = hl.dsp.exec_cmd

        -- notes
        hl.bind("SUPER + N", exec(terminal .. " -e vim ~/tmp/notes"))

        -- applications
        hl.bind("SUPER + Return", exec(terminal .. " --gtk-single-instance=true"))
        hl.bind("CTRL + ALT + L", exec("hyprlock"))
        hl.bind("SUPER + E", exec(file))
        hl.bind("SUPER + B", exec(browser))
        hl.bind("SUPER + SHIFT + B", exec("systemctl --user restart quickshell")) -- Reload the bar
        hl.bind("SUPER + W", exec("qs ipc call bar toggle")) -- Hide/show the bar

        -- Lock lid on close
        hl.bind("switch:on:Lid Switch", exec("hyprlock --immediate"))
        hl.bind("switch:off:Lid Switch", exec("hyprlock --immediate"))

        hl.bind("SUPER + SHIFT + E", exec("$HOME/.scripts/walker-powermenu.sh"))
        hl.bind("SUPER + SPACE", exec("walker"))
        hl.bind("SUPER + V", exec("cliphist list | walker --dmenu | cliphist decode | wl-copy"))

        -- Window Management
        hl.bind("SUPER + Q", hl.dsp.window.close())
        hl.bind("SUPER + SHIFT + Q", hl.dsp.exit())
        hl.bind("SUPER + F", hl.dsp.window.fullscreen())
        hl.bind("SUPER + SHIFT + F", hl.dsp.window.float())
        hl.bind("SUPER + P", hl.dsp.window.pseudo()) -- dwindle
        -- hl.bind("SUPER + S", hl.dsp.layout("togglesplit")) -- dwindle

        hl.bind("SUPER + Tab", function()
          hl.dispatch(hl.dsp.window.cycle_next())
          hl.dispatch(hl.dsp.window.bring_to_top())
        end)

        local directions = { h = "left", l = "right", k = "up", j = "down" }
        local resize = { h = { -20, 0 }, l = { 20, 0 }, k = { 0, -20 }, j = { 0, 20 } }
        for key, direction in pairs(directions) do
          -- Focus
          hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = direction }))
          -- Move
          hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
          -- Resize
          hl.bind("SUPER + CTRL + " .. key, hl.dsp.window.resize({ x = resize[key][1], y = resize[key][2], relative = true }))
        end

        for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          -- Switch
          hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
          -- Move
          hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
        end
        hl.bind("SUPER + ALT + up", hl.dsp.focus({ workspace = "e+1" }))
        hl.bind("SUPER + ALT + down", hl.dsp.focus({ workspace = "e-1" }))

        -- media
        hl.bind("XF86AudioPlay", exec("playerctl play-pause"))
        hl.bind("XF86AudioNext", exec("playerctl next"))
        hl.bind("XF86AudioPrev", exec("playerctl previous"))
        hl.bind("XF86AudioStop", exec("playerctl stop"))
        hl.bind("XF86AudioMute", exec("amixer set Master 1+ toggle"))

        -- binds that repeat when held
        hl.bind("XF86AudioRaiseVolume", exec("amixer set Master 5%+"), { repeating = true })
        hl.bind("XF86AudioLowerVolume", exec("amixer set Master 5%-"), { repeating = true })

        -- laptop brightness, works while locked
        hl.bind("XF86MonBrightnessUp", exec("${brightness} up"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown", exec("${brightness} down"), { locked = true, repeating = true })
        hl.bind("SUPER + XF86MonBrightnessUp", exec("${brightness} max"), { locked = true })
        hl.bind("SUPER + XF86MonBrightnessDown", exec("${brightness} min"), { locked = true })

        -- screenshot
        -- hl.bind("Print", exec("screenshot --copy"))
        -- hl.bind("SUPER + Print", exec("screenshot --save"))
        hl.bind("SUPER + SHIFT + S", exec('grim -g "$(slurp)"'))

        hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
      '';
    };
  };
}
