{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules.pipewire = lib.mkEnableOption "Enable Pipewire config";

  config = lib.mkIf cfg.pipewire {
    security.rtkit.enable = true; # Required for Pipewire real-time access

    environment.systemPackages = with pkgs; [
      alsa-utils
      pavucontrol
    ];
    services.pipewire = {
      enable = true;
      # package = pkgs.stable.pipewire;
      pulse.enable = true;
      jack.enable = true;
      audio.enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    boot.kernelModules = [ "snd-aloop" ];
    services.pipewire.extraConfig.pipewire."50-resolve-aloop-bridge" = {
      "context.modules" = [
        {
          name = "libpipewire-module-loopback";
          args = {
            "node.description" = "DaVinci Resolve Loopback Bridge";
            "capture.props" = {
              "node.name" = "resolve-aloop-capture";
              "target.object" = "alsa_input.platform-snd_aloop.0.analog-stereo";
              "node.passive" = true;
            };
            "playback.props" = {
              "node.name" = "resolve-aloop-playback";
              "media.class" = "Stream/Output/Audio";
            };
          };
        }
      ];
    };
    services.pipewire.wireplumber.extraConfig."51-resolve-aloop-no-default" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            { "node.name" = "alsa_output.platform-snd_aloop.0.analog-stereo"; }
            { "node.name" = "alsa_input.platform-snd_aloop.0.analog-stereo"; }
          ];
          actions = {
            update-props = {
              "priority.session" = 0;
              "priority.driver" = 0;
              "node.dont-fallback" = true;
            };
          };
        }
      ];
    };
  };
}
