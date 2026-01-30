{
  lib,
  config,
  inputs,
  self,
  ...
}:

{

  imports = [
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];
  options.solarsystem = {
    asahi = lib.mkEnableOption "Asahi Linux and Apple Silicon support";
  };

  config = {
    hardware = {

      asahi = {
        enable = config.solarsystem.isLaptop;
        setupAsahiSound = true;

        peripheralFirmwareDirectory = inputs.asahi-firmware;
      };
    };

    nixpkgs.overlays = [
      inputs.apple-silicon.overlays.apple-silicon-overlay
    ];
  };
}
