{ lib, ... }:
let
  importNames = lib.solarsystem.readNix "modules/home";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/home";
}
