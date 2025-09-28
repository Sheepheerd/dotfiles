{
  lib,
  ...
}:
let
  importNames = lib.solarsystem.readNix "modules/home/nvim/plugins/utils";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/home/nvim/plugins/utils";
}
