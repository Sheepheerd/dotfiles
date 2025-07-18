{ lib, ... }:
let
  importNames = lib.solarsystem.readNix "modules/home/common/hyprland";
in
{
  imports = lib.solarsystem.mkImports importNames "modules/home/common/hyprland";
}
