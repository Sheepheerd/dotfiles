{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.solarsystem.modules.bootloader = lib.mkEnableOption "bootloader configuration";

  config = lib.mkIf config.solarsystem.modules.bootloader {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;
    boot.loader.timeout = 2;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.initrd.enable = true;
    boot.initrd.systemd.enable = true;

    boot.consoleLogLevel = 3;
  };
}
