{
  lib,
  config,
  inputs,
  self,
  ...
}:

let
  fairydustKernel = final: prev: {
    linux-asahi = prev.linux-asahi.override (old: {
      argsOverride = {
        src = final.fetchFromGitHub {
          owner = "AsahiLinux";
          repo = "linux";
          rev = "fairydust";
          hash = "sha256-…"; # get from failed build
        };
        version = "asahi-fairydust"; # example
      };
    });
  };
in
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
      graphics.enable = true;
    };

    nixpkgs.overlays = [
      inputs.apple-silicon.overlays.apple-silicon-overlay
    ];

    # FIXME
    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    security.polkit.enable = true;
  };

}
