# shell.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell rec {
  buildInputs = [
    pkgs.python3
    pkgs.python3Packages.virtualenv
  ];
}

