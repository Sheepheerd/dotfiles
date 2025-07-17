{ config, lib, ... }:

with lib;

let
  cfg = config.solarsystem.modules.networking;
in
{
  options.solarsystem.modules.networking = {
    enable = mkEnableOption "Enable custom networking settings";

    hostName = mkOption {
      type = types.str;
      default = "nixos";
      description = "Hostname for this system";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = cfg.hostName;
      networkmanager.enable = true;
    };
  };
}
