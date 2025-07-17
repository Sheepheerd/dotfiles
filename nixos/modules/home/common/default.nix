{ lib, ... }:
let
  importNames = lib.solarsystem.readNix "modules/home/common";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/home/common";
}
