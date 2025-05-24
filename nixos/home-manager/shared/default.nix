{ config, pkgs, inputs, ... }: {
  imports = [ # ./hyprland.nix
    ./zsh.nix
    # ./fish.nix
    ./pkgs.nix
    # ./ghostty.nix
    # ./tmux.nix
    ./nvim
  ];
}
