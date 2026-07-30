{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.solarsystem.modules.hyprland;
in
{
  options.solarsystem.modules.hyprland = lib.mkEnableOption "Enable and configure Hyprland with host-specific behavior";

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      clippy
      awww
      grim
      slurp
      wl-clip-persist
      cliphist
      wf-recorder
      glib
      wayland
      hyprland-qtutils
      wl-clipboard
      kdePackages.qtwayland
      polkit_gnome
      hyprpolkitagent
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      # HM >=26.05 defaults configType to "lua"; our settings/extraConfig are
      # hyprlang, so keep generating hyprland.conf.
      configType = "hyprlang";
      # package = if config.solarsystem.isNixos then null else pkgs.hyprland;
      package = null;
      portalPackage = null;
      xwayland.enable = true;
      systemd.enable = true;
      systemd.variables = [ "--all" ];
    };

    programs.kitty.enable = false;
  };
}
