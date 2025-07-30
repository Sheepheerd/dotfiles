{
  lib,
  config,
  pkgs,
  ...
}:
let
  importNames = lib.solarsystem.readNix "modules/home/nvim/plugins/statusline";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/home/nvim/plugins/statusline";
}
