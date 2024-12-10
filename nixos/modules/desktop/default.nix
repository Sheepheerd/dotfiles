{ pkgs, inputs, ... }: {
  imports = [
    ./development/default.nix
    ./system/default.nix
    ./programs/default.nix
    ./pkgs/default.nix
  ];
}

