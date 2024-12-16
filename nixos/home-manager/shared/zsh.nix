{ inputs, pkgs, ... }: {

  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    envExtra = ''
      bindkey '^ ' autosuggest-accept
      export PATH="$PATH:$HOME/.scripts/bin"
      eval "$(zoxide init zsh)"
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    '';
    plugins = [{
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.8.0";
        sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
      };
    }];

    shellAliases = {
      t = "tmux a";
      open = "xdg-open";
      vim = "nvim";
      fd = "zoxide";
      update =
        "sudo nixos-rebuild switch --flake ~/github/dotfiles/nixos#novastar";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "magic-enter" "fzf" "pyenv" "sudo" "tldr" ];
      theme = "eastwood";
    };
  };
}

