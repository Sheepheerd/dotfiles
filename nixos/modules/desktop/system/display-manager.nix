{ pkgs, ... }:

{

  # services.xserver = {
  # enable = true;
  #   desktopManager.gnome.enable = true;
  #  };

  services.displayManager.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

}
