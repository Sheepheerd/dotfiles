{
  lib,
  config,
  inputs,
  self,
  ...
}:

let
  cfg = config.solarsystem.modules;
in
{

  imports = [
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];
  options.solarsystem = {
    modules.asahi = lib.mkEnableOption "Asahi Linux and Apple Silicon support";
  };

  config = lib.mkIf cfg.asahi {
    hardware.asahi = {
      enable = false;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "replace";
      setupAsahiSound = true;

      peripheralFirmwareDirectory = lib.mkIf (builtins.pathExists (self + "/extrafiles/firmware")) (
        self + "/extrafiles/firmware"
      );
    };

    nixpkgs.overlays = [
      inputs.apple-silicon.overlays.apple-silicon-overlay
    ];
  };
}
