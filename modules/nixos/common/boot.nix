{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.solarsystem.modules.bootloader = lib.mkEnableOption "bootloader configuration";

  config = lib.mkIf config.solarsystem.modules.bootloader {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = false;
        timeout = 2;
      };

      kernelPackages = lib.mkIf (!config.solarsystem.asahi) (lib.mkDefault pkgs.linuxPackages_latest);

      initrd.enable = true;
      initrd.systemd.enable = true;

      consoleLogLevel = 3;
    };
    systemd = {
      # Masking these makes systemctl suspend/hibernate fail outright, so nothing
      # (logind, hypridle, a stray keybind) can put a noSleep host to sleep.
      targets =
        lib.genAttrs
          [
            "sleep"
            "suspend"
            "hibernate"
            "hybrid-sleep"
          ]
          (_: {
            enable =
              if config.solarsystem.noSleep then lib.mkForce false else lib.mkIf config.solarsystem.isLaptop true;
          });

    };
  };
}
