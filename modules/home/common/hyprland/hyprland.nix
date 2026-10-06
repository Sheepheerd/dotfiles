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
      # Generates hyprland.lua; settings/extraConfig in config.nix are Lua.
      configType = "lua";
      # package = if config.solarsystem.isNixos then null else pkgs.hyprland;
      package = null;
      portalPackage = null;
      xwayland.enable = true;
      # On NixOS the session runs under UWSM, which owns graphical-session.target.
      # HM's exec-once that stops/starts hyprland-session.target races it and
      # tears the session down right after login.
      systemd.enable = !config.solarsystem.isNixos;
      systemd.variables = [ "--all" ];
    };

    programs.kitty.enable = false;
  };
}
