{ inputs, pkgs, ... }:

{

  # Enable Hyprland
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true; 
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  environment.systemPackages = with pkgs; [
    hyprpicker
    hyprcursor
    hyprlock
    hypridle
    hyprpaper
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    alacritty 
    neovim
	
    firefox
    zathura
    mpv
    imv
  ];
}
