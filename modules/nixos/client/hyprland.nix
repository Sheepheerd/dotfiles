{ lib, config, ... }:

{
  options.solarsystem.modules.hyprland = lib.mkEnableOption "Enable the Hyprland window manager";

  config = lib.mkIf config.solarsystem.modules.hyprland {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    services.displayManager.gdm = lib.mkIf (!config.solarsystem.isDedicatedGaming) {
      enable = true;
    };
    # services.displayManager.ly = lib.mkIf (!config.solarsystem.isDedicatedGaming) {
    #   enable = true;
    # };
  };
}
