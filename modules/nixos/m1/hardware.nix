{
  lib,
  config,
  inputs,
  self,
  pkgs,
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

      # graphics.package =
      #   # Workaround for Mesa 25.3.0 regression
      #   # https://github.com/nix-community/nixos-apple-silicon/issues/380
      #   assert pkgs.mesa.version == "25.3.1";
      #   (import (fetchTarball {
      #     url = "https://github.com/NixOS/nixpkgs/archive/c5ae371f1a6a7fd27823bc500d9390b38c05fa55.tar.gz";
      #     sha256 = "sha256-4PqRErxfe+2toFJFgcRKZ0UI9NSIOJa+7RXVtBhy4KE=";
      #   }) { localSystem = pkgs.stdenv.hostPlatform; }).mesa;

      asahi = {
        enable = config.solarsystem.isLaptop;
        setupAsahiSound = true;

        peripheralFirmwareDirectory = lib.mkIf (builtins.pathExists (self + "/extrafiles/firmware")) (
          self + "/extrafiles/firmware"
        );
      };
    };

    nixpkgs.overlays = [
      inputs.apple-silicon.overlays.apple-silicon-overlay
    ];
  };
}
