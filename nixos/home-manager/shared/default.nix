{ config, pkgs, inputs, ... }: {
  imports = [ # ./hyprland.nix
    ./zsh.nix
    ./nvim/plugins
    ./pkgs.nix
    ./ghostty.nix
    ./desktop
    ./programs
  ];
}
