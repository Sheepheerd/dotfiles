{ config, lib, ... }:

with lib;

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules = {
    udev = mkEnableOption "Enable udev service";

  };

  config = mkIf cfg.udev {
    services.udev.extraRules = ''

      SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", GROUP="plugdev", MODE="0666"    
    '';
  };
}
