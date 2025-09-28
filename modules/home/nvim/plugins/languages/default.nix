{
  lib,
  ...
}:
let
  importNames = lib.solarsystem.readNix "modules/home/nvim/plugins/languages";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/home/nvim/plugins/languages";
}
