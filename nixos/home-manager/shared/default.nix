{ config, pkgs, inputs, ... }: {
  imports = [ # ./hyprland.nix
    ./zsh.nix
    ./pkgs.nix
    ./ghostty.nix
    ./rice
    ./tmux.nix
    ./nvim
  ];
}
