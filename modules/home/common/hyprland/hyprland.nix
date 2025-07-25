{
  config,
  pkgs,
  lib,
  inputs,
  host,
  ...
}:

let
  cfg = config.solarsystem.modules.hyprland;
in
{
  options.solarsystem.modules.hyprland = lib.mkEnableOption "Enable and configure Hyprland with host-specific behavior";

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      swww
      grim
      slurp
      wl-clip-persist
      cliphist
      wf-recorder
      glib
      wayland
      hyprland-qtutils
      wl-clipboard
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = if config.solarsystem.isNixos then null else pkgs.hyprland;
      portalPackage = if config.solarsystem.isNixos then null else pkgs.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };

    programs.kitty.enable = false;
  };
}
