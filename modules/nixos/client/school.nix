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

      coreutils
      qucs-s
      gtkwave
      # ghdl
      nvc
      virt-manager
      octaveFull
      quickemu
      libqalculate
    ];
  };
}
