{ config, pkgs, inputs, ... }: {
  imports = [ # ./hyprland.nix
    ./zsh.nix
    ./pkgs.nix
    ./ghostty.nix
    ./desktop
    ./tmux.nix
    ./nvim
  ];
}
