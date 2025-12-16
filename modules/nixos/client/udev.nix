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
      # TI-Nspire
      SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e012", ENV{ID_PDA}="1"
      # TI-Nspire CX II
      SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e022", ENV{ID_PDA}="1"

      SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", GROUP="plugdev, MODE="0666""
    '';
  };
}
