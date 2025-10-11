{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

{
  options.solarsystem.modules.box = lib.mkEnableOption "Box64 binfmt";

  # imports = [
  #   inputs.box64-binfmt.nixosModules.default
  # ];
  config = lib.mkIf config.solarsystem.modules.box {
    # box64-binfmt.enable = true; # Disable
    # environment.systemPackages = [
    #   pkgs.x86.wineWowPackages.stable # WINE (WoW64 version)
    #
    # ];

  };
}
