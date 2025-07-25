{ lib, ... }:
let
  importNames = lib.solarsystem.readNix "modules/home/nvim";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/home/nvim";
}
