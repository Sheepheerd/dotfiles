{ lib, ... }:
let
  importNames = lib.solarsystem.readNix "modules/nixos/media";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/nixos/media";
}
