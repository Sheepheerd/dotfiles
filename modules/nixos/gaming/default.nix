{ lib, ... }:
let
  importNames = lib.solarsystem.readNix "modules/nixos/gaming";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/nixos/gaming";
}
