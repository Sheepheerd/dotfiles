{
  lib,
  config,
  inputs,
  self,
  pkgs,
  ...
}:

{

  # imports = [
  #   inputs.box64-binfmt.nixosModules.default
  # ];
  options.solarsystem.modules = {
    box64Asahi = lib.mkEnableOption "Box64 for Asahi";
  };

  config = {

    box64-binfmt.enable = false; # Enable
    boot.binfmt.emulatedSystems = [
      "i686-linux"
      "x86_64-linux"
      "i386-linux"
      "i486-linux"
      "i586-linux"
      "i686-linux"
    ];
    nix.settings.extra-platforms = [
      "i686-linux"
      "x86_64-linux"
      "i386-linux"
      "i486-linux"
      "i586-linux"
      "i686-linux"
    ];
    environment.systemPackages = [
      # pkgs.x86.wineWowPackages.stable # WINE (WoW64 version)
      # This is the box64 version with box32 experimental support built, it is alrerady installed so this is not needed
      # inputs.box64-binfmt.packages.${pkgs.system}.box64-bleeding-edge
    ];

  };
}
