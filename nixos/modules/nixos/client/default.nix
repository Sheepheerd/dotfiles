{ lib, ... }:
let
  importNames = lib.solarsystem.readNix "modules/nixos/client";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/nixos/client";
}
