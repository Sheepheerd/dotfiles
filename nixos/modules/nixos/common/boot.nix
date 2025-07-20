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
      targets = {
        sleep.enable = lib.mkIf config.solarsystem.isLaptop true;
        suspend.enable = lib.mkIf config.solarsystem.isLaptop true;
        hibernate.enable = lib.mkIf config.solarsystem.isLaptop true;
        hybrid-sleep.enable = lib.mkIf config.solarsystem.isLaptop true;

      };

    };
  };
}
