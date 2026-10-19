{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

{
  options.solarsystem.modules.hyprland = lib.mkEnableOption "Enable the Hyprland window manager";

  config = lib.mkIf config.solarsystem.modules.hyprland {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # portalPackage =
      #   inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };

    # services.displayManager.gdm = lib.mkIf (!config.solarsystem.isDedicatedGaming) {
    #   enable = false;
    # };
    # Plain hyprland.desktop never reaches graphical-session.target, so the
    # elephant and walker user services would silently not start.
    services.displayManager.defaultSession = lib.mkIf (!config.solarsystem.isDedicatedGaming) "hyprland-uwsm";
    services.displayManager.sddm = lib.mkIf (!config.solarsystem.isDedicatedGaming) {
      enable = true;
      wayland.enable = true;
      # Otherwise sddm preselects whatever session was used last, which can
      # keep landing on plain hyprland.desktop despite defaultSession.
      settings.Users.RememberLastSession = false;
    };
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-wlr
      ];
    };
    # services.displayManager.ly = lib.mkIf (!config.solarsystem.isDedicatedGaming) {
    #   enable = true;
    # };
  };
}
