{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.solarsystem.modules.desktop = lib.mkEnableOption "desktop settings";
  config = lib.mkIf config.solarsystem.modules.desktop {
    xdg.desktopEntries = {

      # teamsNoGpu = {
      #   name = "Microsoft Teams (no GPU)";
      #   genericName = "Teams (no GPU)";
      #   exec = "teams-for-linux --disableGpu=true --trayIconEnabled=true";
      #   terminal = false;
      #   categories = [ "Application" ];
      # };
    };

    xdg.mimeApps = {

      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/chrome" = [ "firefox.desktop" ];
        "text/plain" = [ "nvim.desktop" ];
        "text/csv" = [ "nvim.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "text/markdown" = [ "nvim.desktop" ];
        "application/x-extension-htm" = [ "firefox.desktop" ];
        "application/x-extension-html" = [ "firefox.desktop" ];
        "application/x-extension-shtml" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "application/x-extension-xhtml" = [ "firefox.desktop" ];
        "application/x-extension-xht" = [ "firefox.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/gif" = [ "imv.desktop" ];
        "image/svg" = [ "imv.desktop" ];
        "image/webp" = [ "firefox.desktop" ];
        "image/vnd.adobe.photoshop" = [ "gimp.desktop" ];
        "image/vnd.dxf" = [ "org.inkscape.Inkscape.desktop" ];
        "audio/flac" = [ "mpv.desktop" ];
        "audio/mp3" = [ "mpv.desktop" ];
        "audio/ogg" = [ "mpv.desktop" ];
        "audio/wav" = [ "mpv.desktop" ];
        "video/mp4" = [ "umpv.desktop" ];
        "video/mkv" = [ "umpv.desktop" ];
        "video/flv" = [ "umpv.desktop" ];
        "video/3gp" = [ "umpv.desktop" ];
        "application/pdf" = [ "firefox.desktop" ];
        "application/metalink+xml" = [ "nvim.desktop" ];
        "application/sql" = [ "nvim.desktop" ];
        "application/vnd.ms-powerpoint" = [ "impress.desktop" ];
        "application/msword" = [ "writer.desktop" ];
        "application/vnd.ms-excel" = [ "calc.desktop" ];
      };
      associations = {
        added = {
          "application/x-zerosize" = [ "nvim.desktop" ];
        };
      };
    };
  };
}
