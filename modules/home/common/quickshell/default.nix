{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.solarsystem.modules.quickshell;
in
{
  options.solarsystem.modules.quickshell = lib.mkEnableOption "Enable the quickshell status bar";

  config = lib.mkIf cfg {
    home.packages = [ pkgs.quickshell ];

    # Linked file by file rather than as one store symlink, so quickshell's own
    # file watcher can see changes and hot-reload the bar.
    xdg.configFile."quickshell" = {
      source = ./qml;
      recursive = true;
    };

    systemd.user.services.quickshell = {
      Unit = {
        Description = "Quickshell status bar";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        # The QML lives outside the unit, so name its store path here to get
        # the service restarted when the bar changes.
        X-Restart-Triggers = [ "${./qml}" ];
      };
      Service = {
        # -n keeps a stray second instance from stacking another bar on top.
        ExecStart = "${pkgs.quickshell}/bin/quickshell -n";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
