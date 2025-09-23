{
  lib,
  config,
  ...
}:

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules.steam = lib.mkEnableOption "Enable distrobox config";

  config = lib.mkIf cfg.steam {
    #enable Steam: https://linuxhint.com/how-to-instal-steam-on-nixos/
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
