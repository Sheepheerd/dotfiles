{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  options.solarsystem.modules.youtube = lib.mkEnableOption "youtube config";
  config = lib.mkIf config.solarsystem.modules.youtube {

    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        droidcam-obs
        obs-vaapi
      ];
    };

    environment.systemPackages = with pkgs; [
      kdePackages.kdenlive
      v4l-utils
      scrcpy
      # systemctl --user enable --now wayscriber.service
      inputs.wayscriber.packages.${pkgs.system}.default
      inputs.wayscriber.packages.${pkgs.system}.wayscriber-configurator
      gimp

    ];

    boot = {
      # Make v4l2loopback kernel module available to NixOS.
      extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      # Activate kernel module(s).
      kernelModules = [
        # Virtual camera.
        "v4l2loopback"
        # Virtual Microphone. Custom DroidCam v4l2loopback driver needed for audio.
        #    "snd-aloop"
      ];
    };

  };
}
