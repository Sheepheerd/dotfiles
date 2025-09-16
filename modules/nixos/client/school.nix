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
  options.solarsystem.modules.school = lib.mkEnableOption "Enable school stuff";

  config = lib.mkIf cfg.school {

    programs.virt-manager.enable = true;

    users.groups.libvirtd.members = [ "sheep" ];

    virtualisation.libvirtd.enable = true;

    virtualisation.spiceUSBRedirection.enable = true;

    environment.systemPackages = with pkgs; [
      (lib.mkIf (!config.solarsystem.isLaptop) matlab)
      (lib.mkIf (!config.solarsystem.isLaptop) vivado)

      coreutils
      qucs-s
      gtkwave
      # ghdl
      nvc
      virt-manager
      libqalculate
      wayvnc
      remmina

    ];

    services.udev.extraRules = ''
      # TI-Nspire
      SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e012", ENV{ID_PDA}="1"
      # TI-Nspire CX II
      SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="e022", ENV{ID_PDA}="1"
    '';
  };
}
