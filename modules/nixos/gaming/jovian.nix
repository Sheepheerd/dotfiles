#
# jovian.nix -- Gaming
#
{
  config,
  lib,
  ...
}:
let
  gameuser = "sheep";
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules.jovian = lib.mkEnableOption "Enable jovian config";

  config = lib.mkIf cfg.jovian {

    # These are all the unfree dependencies required by `jovian.steam.enable`
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steamdeck-hw-theme"
        "steam-jupiter-unwrapped"
        "steam"
      ];

    jovian = {
      steam = {
        user = gameuser;
        enable = true;
        autoStart = true;
        desktopSession = "hyprland";
      };
      hardware.has.amd.gpu = true;
    };

    services.xserver.enable = true;
  };
}
