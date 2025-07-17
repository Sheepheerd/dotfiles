{
  lib,
  config,
  inputs,
  self,
  ...
}:

let
  asahiEnabled = config.solarsystem.modules.asahi;
in
{
  options.solarsystem.modules.asahi = lib.mkEnableOption "Asahi Linux and Apple Silicon support";

  config = lib.mkIf asahiEnabled {
    hardware.asahi = {
      enable = true;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "replace";
      setupAsahiSound = true;
      peripheralFirmwareDirectory = self + /extrafiles/firmware;
    };

    # Only include overlay if you want to hardcode it:
    nixpkgs.overlays = [
      inputs.apple-silicon.overlays.apple-silicon-overlay
    ];
  };
}
