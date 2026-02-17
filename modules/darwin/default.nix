{ lib, ... }:
let
  importNames = lib.solarsystem.readNix "modules/darwin";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/darwin";
}
