{ lib, ... }:
let
  importNames = lib.solarsystem.readNix "modules/nixos/m1";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/nixos/m1";
}
