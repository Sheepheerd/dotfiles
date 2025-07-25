{ lib, ... }:
let
  importNames = lib.solarsystem.readNix "modules/nixos/server";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/nixos/server";
}
