{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules.school = lib.mkEnableOption "Enable school stuff";

  config = lib.mkIf cfg.school {

    environment.systemPackages = with pkgs; [
      (lib.mkIf (!config.solarsystem.isLaptop) matlab)
      (lib.mkIf (!config.solarsystem.isLaptop) vivado)
      (lib.mkIf (!config.solarsystem.isLaptop) wineWowPackages.waylandFull)
      (lib.mkIf (config.solarsystem.isLaptop
      ) inputs.openconnect-sso.packages.${pkgs.system}.openconnect-sso)

      coreutils
      libqalculate
      wayvnc
      remmina
      waypipe
      xorg.xauth
      gemini-cli

    ];

    services.udev.extraRules = ''
      # TI-Nspire
      SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e012", ENV{ID_PDA}="1"
      # TI-Nspire CX II
      SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e022", ENV{ID_PDA}="1"
    '';
  };
}
