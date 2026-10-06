{ lib, config, ... }:

{
  # The quickshell bar reads the battery through UPower and hides the module
  # when no laptop battery shows up, so desktops never need this.
  config = lib.mkIf config.solarsystem.asahi {
    services.upower.enable = true;
  };
}
