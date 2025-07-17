{ lib, ... }:
let
  profileNames = lib.solarsystem.readNix "profiles/home";
in
{
  imports = lib.solarsystem.mkImports profileNames "profiles/home";
}
