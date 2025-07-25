{ lib, ... }:
let
  profileNames = lib.solarsystem.readNix "profiles/nixos";
in
{
  imports = lib.solarsystem.mkImports profileNames "profiles/nixos";
}
