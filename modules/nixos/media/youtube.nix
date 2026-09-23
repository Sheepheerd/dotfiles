{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  # godot-ai hard-pins fastmcp 4 / mcp 2, which nixpkgs doesn't carry, so run
  # it through uvx (the upstream-supported launcher) against nixpkgs' python.
  godot-ai = pkgs.writeShellScriptBin "godot-ai" ''
    export UV_PYTHON=${pkgs.python3}/bin/python3
    export UV_PYTHON_DOWNLOADS=never
    exec ${pkgs.uv}/bin/uvx godot-ai "$@"
  '';
in
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
      gimp
      audacity
      godot
      blender
      inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
      uv
      godot-ai
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
      extraModprobeConfig = ''
        options v4l2loopback video_nr=10 card_label="scrcpy-cam" exclusive_caps=1
      '';
    };

  };
}
