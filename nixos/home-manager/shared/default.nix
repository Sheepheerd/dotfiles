{ config, pkgs, inputs, host, ... }: {
  imports = [ ./zsh.nix ./pkgs.nix ./ghostty.nix ./rice ./tmux.nix ./nvim ];
}
