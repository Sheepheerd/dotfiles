{ pkgs, inputs, ... }: {
  imports = [
    ./system/default.nix
    ./programs/default.nix
    ../shared/default.nix
  ];

}
