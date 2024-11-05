{ pkgs, ... }:

{
services.displayManager.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

}
