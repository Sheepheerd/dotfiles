{ self, lib, ... }:
let
  importNames = lib.solarsystem.readNix "modules/nixos/common";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/nixos/common" ++ [
    "${self}/modules/home/common/sharedsetup.nix"
  ];

}
