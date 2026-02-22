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

  config = lib.mkIf config.solarsystem.asahi {
    hardware = {

      asahi = {
        enable = config.solarsystem.asahi;
        setupAsahiSound = true;

        peripheralFirmwareDirectory = inputs.asahi-firmware;
      };
      graphics.enable = true;
    };

    nixpkgs.overlays = [
      inputs.apple-silicon.overlays.apple-silicon-overlay
      (final: prev: {
        linux-fairydust = final.callPackage "${self}/pkgs/linux-asahi" { };
      })

    ];

    # Monitor Support
    services.logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "ignore";
      lidSwitchDocked = "ignore";
    };
    boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.linux-fairydust);

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
