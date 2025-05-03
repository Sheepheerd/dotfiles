{ config, pkgs, inputs, ... }: {
  imports = [ # ./hyprland.nix
    # ./zsh.nix
    ./terminal.nix
    ./pkgs.nix
    ./ghostty.nix
    ./desktop
    ./programs
    ./tmux.nix
  ];
}
