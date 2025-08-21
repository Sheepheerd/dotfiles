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

    environment.systemPackages = with pkgs; [
      coreutils
      qucs-s
      gtkwave
      # ghdl
      nvc
      octaveFull
    ];

  };
}
