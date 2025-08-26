{ lib, config, ... }:

{
  options.solarsystem.modules.hyprland = lib.mkEnableOption "Enable the Hyprland window manager";

  config = lib.mkIf config.solarsystem.modules.hyprland {
    programs.hyprland.enable = true;
    services.displayManager.gdm.enable = true;
  };
}
