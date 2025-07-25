pkgs: {
  Service = {
    Type = "dbus";
    BusName = "com.github.wwmm.easyeffects";
    ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
    Restart = "always";
  };
}

