#
# jovian.nix -- Gaming
#
{
  config,
  lib,
  ...
}:
let
  # Local user account for auto login
  # Separate and distinct from Steam login
  # Can be any name you like
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
      steam.enable = true;
      hardware.has.amd.gpu = true;
    };

    services.xserver.enable = true;
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      settings = {
        General = {
          # Scale SDDM UI by 2x for TV
          GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=2";
        };
      };
    };
  };
}
