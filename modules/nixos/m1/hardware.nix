{
  lib,
  config,
  inputs,
  self,
  ...
}:

let
  cfg = config.solarsystem;
in
{

  imports = [
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];
  options.solarsystem = {
    asahi = lib.mkEnableOption "Asahi Linux and Apple Silicon support";
  };

  config = {
    hardware.asahi = {
      enable = config.solarsystem.isLaptop;
      # enable = true;
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
