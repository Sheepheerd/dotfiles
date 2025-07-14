{
  pkgs,
  inputs,
  lib,
  host,
  ...
}:
let

  package = if host == "novastar" then pkgs.hyprland else null;
  portal = if host == "novastar" then pkgs.xdg-desktop-portal-hyprland else null;
in
{

  home.packages = with pkgs; [
    swww
    # inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    # inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
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

  programs = {
    # hyprlock = { enable = true; };
    # hyprlidle = { enable = true; };
    # hyprpolkitagent.enable = true;
    # hyprsunset.enable = true;
  };

  wayland.windowManager.hyprland = {

    enable = true;
    package = package;
    portalPackage = portal;
    xwayland = {
      enable = true;
    };

  };

  programs.kitty.enable = false; # required for the default Hyprland config

}
