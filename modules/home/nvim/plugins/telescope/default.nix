{
  lib,
  ...
}:
let
  importNames = lib.solarsystem.readNix "modules/home/nvim/plugins/telescope";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/home/nvim/plugins/telescope";
}
