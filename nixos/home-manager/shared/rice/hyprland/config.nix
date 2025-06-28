{ host, ... }:
let
  browser = "firefox";
  terminal = "ghostty";
  file = "nemo";

  monitor = if host == "novastar" then
    "monitor = eDP-1 ,2560x1600@60, 0x0, 1.25"
  else
  #fix this for dual monitors
    "monitor = auto,2560x1600@60, 0x0, 1.25";
in {
  wayland.windowManager.hyprland = {
    settings = {
      plugins = [ "hyprland-polkit" ];
      exec-once = [
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        "waybar &"
        "swww-daemon &"
        # "hyprlock"

        "wl-clip-persist --clipboard both &"
        "wl-paste --watch cliphist store &"
        "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

        "${terminal} --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
        "[workspace 1 silent] ${browser}"
        "[workspace 2 silent] ${terminal}"
      ];

      input = {
        kb_layout = "us";
        kb_options = [ "shift:both_capslock" "caps:ctrl_modifier" ];
        numlock_by_default = true;
        repeat_delay = 300;
        follow_mouse = 0;
        sensitivity = 0.5;
        touchpad = {
          disable_while_typing = true;
          scroll_factor = 0.3;
          natural_scroll = true;
        };

        force_no_accel = 0;
        accel_profile = "flat";
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_cancel_ratio = 0.15;

      };

      general = {
        "$mainMod" = "SUPER";
        layout = "dwindle";
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        # col.active_border = "rgba(e5b9c6ff) rgba(c293a3ff) 45deg";
        # col.inactive_border = "0xff382D2E";
        no_border_on_floating = false;
      };

      misc = {

        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        vfr = true;
        vrr = 0;
        animate_manual_resizes = true;
        mouse_move_focuses_monitor = true;
        enable_swallow = true;
      };

      dwindle = {
        pseudotile =
          true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      decoration = {

        rounding = 6;
        # multisample_edges = true

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

      animations = {
        enabled = true;

        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1, 0.1, 1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];

        animation = [
          "windows, 1, 6, wind, popin"
          "windowsIn, 1, 6, winIn, popin"
          "windowsOut, 1, 5, winOut, popin"
          "windowsMove, 1, 5, wind, popin"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      bind = [

        # applications
        "$mainMod, Return, exec, ${terminal} --gtk-single-instance=true"
        "CTRL ALT, L, exec, hyprlock"
        "SUPER, E, exec, ${file}"
        "SUPER, B, exec,  ${browser}"
        "SUPER SHIFT, B, exec, killall -SIGUSR2 waybar" # Reload waybar
        "SUPER, W, exec, killall -SIGUSR1 waybar"

        ",switch:on:Lid Switch, exec, hyprlock --immediate"
        # Lock lid on close
        ",switch:off:Lid Switch, exec, hyprlock --immediate"

        "SUPER SHIFT, E, exec, $HOME/.scripts/fuzzel-powermenu.sh"
        "SUPER, C, exec, killall fuzzel ||  $HOME/.scripts/fuzzel-calculator.sh"
        "SUPER, A, exec, killall fuzzel || fuzzel"
        "SUPER, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"

        # Window Management
        "SUPER, Q, killactive,"
        "SUPER SHIFT, Q, exit,"
        "SUPER, F, fullscreen,"
        "SUPER, Space, togglefloating,"
        "SUPER, P, pseudo, # dwindle"
        "SUPER, S, togglesplit, # dwindle"

        # Change Workspace Mode
        "SUPER SHIFT, Space, workspaceopt, allfloat"
        "SUPER SHIFT, Space, exec, $notifycmd 'Toggled All Float Mode'"
        "SUPER SHIFT, P, workspaceopt, allpseudo"
        "SUPER SHIFT, P, exec, $notifycmd 'Toggled All Pseudo Mode'"

        "SUPER, Tab, cyclenext,"
        "SUPER, Tab, bringactivetotop,"

        # Focus
        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"

        # Move
        "SUPER SHIFT, h, movewindow, l"
        "SUPER SHIFT, l, movewindow, r"
        "SUPER SHIFT, k, movewindow, u"
        "SUPER SHIFT, j, movewindow, d"

        # Resize
        "SUPER CTRL, h, resizeactive, -20 0"
        "SUPER CTRL, l, resizeactive, 20 0"
        "SUPER CTRL, k, resizeactive, 0 -20"
        "SUPER CTRL, j, resizeactive, 0 20"

        # Switch
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"
        "SUPER ALT, up, workspace, e+1"
        "SUPER ALT, down, workspace, e-1"

        # Move
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        ",XF86AudioPlay,exec, playerctl play-pause"
        ",XF86AudioNext,exec, playerctl next"
        ",XF86AudioPrev,exec, playerctl previous"
        ",XF86AudioStop,exec, playerctl stop"
        ",XF86AudioMute,exec, pamixer -t"
        # # binds that repeat when held

        # screenshot
        ",Print, exec, screenshot --copy"
        "$mainMod, Print, exec, screenshot --save"
        "$mainMod SHIFT, Print, exec, screenshot --swappy"

      ];
      binde = [
        ",XF86AudioRaiseVolume,exec, pamixer -i 2"
        ",XF86AudioLowerVolume,exec, pamixer -d 2"
      ];

      bindl = [
        # laptop brigthness
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        "$mainMod, XF86MonBrightnessUp, exec, brightnessctl set 100%+"
        "$mainMod, XF86MonBrightnessDown, exec, brightnessctl set 100%-"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

    };
    extraConfig = ''
            ${monitor}

            env = PATH,$HOME/.nix-profile/bin:$HOME/.nix-profile/sbin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin

            env = NIX_PATH,nixpkgs=/nix/var/nix/profiles/per-user/$USER/channels/nixpkgs

            env = NIX_PROFILES,/nix/var/nix/profiles/default $HOME/.nix-profile"


      env =      _JAVA_AWT_WM_NONEREPARENTING , 1
      env =      # SSH_AUTH_SOCK , "/run/user/1000/ssh-agent"
      env =      DISABLE_QT5_COMPAT , 0
      env =      GDK_BACKEND , "wayland"
      env =      DIRENV_LOG_FORMAT , ""
      env =      QT_AUTO_SCREEN_SCALE_FACTOR , 1
      env =      QT_WAYLAND_DISABLE_WINDOWDECORATION , 1
      env =      QT_QPA_PLATFORM , "xcb"
      env =      QT_QPA_PLATFORMTHEME , "qt5ct"
      env =      QT_STYLE_OVERRIDE , "kvantum"
      env =      MOZ_ENABLE_WAYLAND , 1
      env =      # WLR_BACKEND , "vulkan"
      env =      # WLR_RENDERER , "vulkan"
      env =      WLR_NO_HARDWARE_CURSORS , 1
      env =      XDG_CURRENT_DESKTOP , "Hyprland"
      env =      XDG_SESSION_TYPE , "wayland"
      env =      XDG_SESSION_DESKTOP , "Hyprland"
      env =      SDL_VIDEODRIVER , "wayland"
      env =      CLUTTER_BACKEND , "wayland"
      env =      # GTK_THEME , "Colloid-Green-Dark-Gruvbox"
      env =      GRIMBLAST_HIDE_CURSOR , 0
      env =      ELECTRON_OZONE_PLATFORM_HINT , "wayland"
      env =      OZONE_PLATFORM , "wayland"


    '';
    #

    # xwayland {        force_zero_scaling = true      }    ";
    systemd.enable = true;
  };

}
