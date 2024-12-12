{ pkgs, pkgs-unstable, ... }:

{

  environment.systemPackages = with pkgs; [ godot_4 ];
}

