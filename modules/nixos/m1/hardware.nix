{
  lib,
  config,
  inputs,
  pkgs,
  self,
  ...
}:

let
  # See the nixpkgs-kernel input in flake.nix: a pinned nixpkgs so updating the
  # system's nixpkgs does not recompile the kernel.
  kernelPkgs = import inputs.nixpkgs-kernel {
    inherit (pkgs.stdenv.hostPlatform) system;
  };
in
{

  imports = [
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];
  options.solarsystem = {
    asahi = lib.mkEnableOption "Asahi Linux and Apple Silicon support";
  };

  # Every host imports modules/nixos/m1, so all of it hangs off the asahi flag.
  # hardware.asahi.enable sits outside the mkIf because apple-silicon-support
  # defaults it to true, so the other hosts have to switch it off explicitly.
  config = lib.mkMerge [
    { hardware.asahi.enable = config.solarsystem.asahi; }
    (lib.mkIf config.solarsystem.asahi {
      hardware = {

        asahi = {
          setupAsahiSound = true;
          #extractPeripheralFirmware = false;

          peripheralFirmwareDirectory = inputs.asahi-firmware;
        };
        # graphics.enable = config.solarsystem.asahi;

      };

      # Asahi's experimental fairydust branch: the stock asahi kernel plus USB-C
      # DisplayPort alt-mode, wired to a single port (hpm1, the front-left one
      # on the Air). Version and source live in pkgs/linux-asahi. Drop this
      # block to go back to the stock kernel. Out-of-tree modules come from the
      # same pinned set, so they are built with the kernel's own compiler.
      boot.kernelPackages = lib.mkForce (
        kernelPkgs.linuxPackagesFor (
          kernelPkgs.callPackage "${self}/pkgs/linux-asahi" {
            _kernelPatches = config.boot.kernelPatches;
          }
        )
      );

      # FIXME
      boot.extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      boot.extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
      security.polkit.enable = true;
    })
  ];

}
