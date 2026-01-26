{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.solarsystem.modules.kodi = lib.mkEnableOption "kodi config";
  config = lib.mkIf config.solarsystem.modules.kodi {

    services.xserver.enable = true;
    services.xserver.desktopManager.kodi.enable = true;
    services.displayManager.autoLogin.user = "kodi";
    services.xserver.displayManager.lightdm.greeter.enable = false;

    # Define a user account
    users.extraUsers.kodi.isNormalUser = true;

  };
}
