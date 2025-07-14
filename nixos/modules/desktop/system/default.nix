{ pkgs, inputs, ... }:
{
  imports = [
    ./config.nix
    ./virtualisation.nix
  ];
}
