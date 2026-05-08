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

    services.displayManager.gdm = lib.mkIf (!config.solarsystem.isDedicatedGaming) {
      enable = true;
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
