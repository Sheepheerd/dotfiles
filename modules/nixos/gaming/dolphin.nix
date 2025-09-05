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
  options.solarsystem.modules.dolphin = lib.mkEnableOption "Enable dolphin config";

  config = lib.mkIf cfg.dolphin {
    # boot.extraModulePackages = [
    #   config.boot.kernelPackages.gcadapter-oc-kmod
    # ];

    # to autoload at boot:
    # boot.kernelModules = [
    #   "gcadapter_oc"
    # ];
    environment.systemPackages = with pkgs; [
      dolphin-emu
    ];
  };
}
