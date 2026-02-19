{ lib, config, ... }:

let
  hyprlandEnabled = config.solarsystem.modules.hyprland;
in
{
  config = lib.mkIf hyprlandEnabled {
    home.sessionVariables = lib.mkMerge [
      {
        _JAVA_AWT_WM_NONEREPARENTING = 1;
        GDK_BACKEND = "wayland";
        DIRENV_LOG_FORMAT = "";
        QT_AUTO_SCREEN_SCALE_FACTOR = 0;
        QT_SCALE_FACTOR = 1;
        QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_STYLE_OVERRIDE = "kvantum";
        MOZ_ENABLE_WAYLAND = 1;
        WLR_NO_HARDWARE_CURSORS = 1;
        XDG_CURRENT_DESKTOP = "Hyprland";
        WLR_RENDERER_ALLOW_SOFTWARE = "1";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        GRIMBLAST_HIDE_CURSOR = 0;
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        OZONE_PLATFORM = "auto";
      }

      # (lib.mkIf isLaptop {
      #   # GSK_RENDERER = "ngl";
      #   WLR_DRM_DEVICES = "/dev/dri/card0";
      # })

      # (lib.mkIf (!isLaptop) {
      #   libva_driver_name = "nvidia";
      # })
    ];
  };
}
