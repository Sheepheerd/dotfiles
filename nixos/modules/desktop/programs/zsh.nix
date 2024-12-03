{ inputs, pkgs, ... }: {

  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellInit = ''
      bindkey '^ ' autosuggest-accept
      export PATH="$PATH:$HOME/.scripts/bin"
      eval "$(zoxide init zsh)"
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    '';

    shellAliases = {
      t = "tmux a";
      open = "xdg-open";
      vim = "nvim";
      fd = "zoxide";
      update =
        "sudo nixos-rebuild switch --flake ~/github/dotfiles/nixos#deathstar";
    };

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "magic-enter" "fzf" "pyenv" "sudo" "tldr" ];
      theme = "eastwood";
    };
  };
}
