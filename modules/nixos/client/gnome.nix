{
  lib,
  config,
  ...
}:

{
  options.solarsystem.modules.gnome = lib.mkEnableOption "Enable the gnome window manager";

  config = lib.mkIf config.solarsystem.modules.gnome {

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

  };
}
