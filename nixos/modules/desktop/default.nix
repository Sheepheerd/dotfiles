{ pkgs, inputs, ... }: {
  imports = [
    ./system/default.nix
    ./programs/default.nix
    ./pkgs/default.nix
    ../shared/default.nix
  ];

}
