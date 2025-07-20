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
  options.solarsystem.modules.pipewire = lib.mkEnableOption "Enable Pipewire config";

  config = lib.mkIf cfg.pipewire {
    security.rtkit.enable = true; # Required for Pipewire real-time access

    environment.systemPackages = with pkgs; [
      alsa-utils
      pavucontrol
    ];
    services.pipewire = {
      enable = true;
      # package = pkgs.stable.pipewire;
      pulse.enable = true;
      jack.enable = true;
      audio.enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };
}
