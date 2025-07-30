{
  lib,
  config,
  pkgs,
  ...
}:
let
  importNames = lib.solarsystem.readNix "modules/home/nvim/plugins/completion";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/home/nvim/plugins/completion";
}
