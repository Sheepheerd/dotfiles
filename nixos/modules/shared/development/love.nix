{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ love ];
}

