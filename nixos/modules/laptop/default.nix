{ pkgs, inputs, ... }: {
  imports = [
    ../shared/default.nix
    ./system/default.nix
    ./programs/default.nix
    ./pkgs/default.nix
  ];
}

