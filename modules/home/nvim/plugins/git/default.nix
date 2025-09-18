{
  lib,
  ...
}:
let
  importNames = lib.solarsystem.readNix "modules/home/nvim/plugins/git";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/home/nvim/plugins/git";
}
