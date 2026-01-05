{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules.steam = lib.mkEnableOption "Enable distrobox config";

  config = lib.mkIf cfg.steam {
    #enable Steam: https://linuxhint.com/how-to-instal-steam-on-nixos/

    programs.gamescope = {
      enable = true;
      capSysNice = true; # Allows better priority for games
    };

    environment.systemPackages = with pkgs; [
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
    ];
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = [ "gtk" ];
    };

    services.displayManager.autoLogin = {
      enable = true;
      user = "sheep";
    };
    programs.gamemode.enable = true;

    boot.plymouth.enable = true;
    boot.kernelParams = [
      "quiet"
      "splash"
    ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
