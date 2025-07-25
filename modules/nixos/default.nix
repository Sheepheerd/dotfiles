{ lib, ... }:
let
  importNames = lib.solarsystem.readNix "modules/nixos";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/nixos";
}
