{ lib, host, config, ... }: {
  home.sessionVariables = lib.mkMerge [
    {
      _JAVA_AWT_WM_NONEREPARENTING = 1;
      # SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";
      DISABLE_QT5_COMPAT = 0;
      GDK_BACKEND = "wayland";
      DIRENV_LOG_FORMAT = "";
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      QT_QPA_PLATFORM = "xcb";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "kvantum";
      MOZ_ENABLE_WAYLAND = 1;
      # WLR_BACKEND = "vulkan";
      # WLR_RENDERER = "vulkan";
      WLR_NO_HARDWARE_CURSORS = 1;
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      # GTK_THEME = "Colloid-Green-Dark-Gruvbox";
      GRIMBLAST_HIDE_CURSOR = 0;
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      OZONE_PLATFORM = "wayland";
    }
    (lib.mkIf (host == "deathstar") { libva_driver_name = "nvidia"; })
    (lib.mkIf (host == "novastar") { GSK_RENDERER = "gl"; })
  ];
}
