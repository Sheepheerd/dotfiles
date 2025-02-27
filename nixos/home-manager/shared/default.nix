{ config, pkgs, inputs, ... }: {
  imports = [ ./zsh.nix ./nvim/plugins ./pkgs.nix ./ghostty.nix ];
}
