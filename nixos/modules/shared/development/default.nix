{ pkgs, inputs, ... }: {
  imports = [
    ./programming-languages.nix
    ./terminal-utils.nix
    ./godot.nix
    ./direnv.nix
  ];

  nix.extraOptions = ''
    trusted-users = root sheep
  '';
}
