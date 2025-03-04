{ inputs, config, pkgs, ... }:
let
  system = pkgs.system;
  homeDir = config.home.homeDirectory;
in {
  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
  home.file.".zshthemes/eastwood.zsh-theme" = {
    text = ''
      # RVM settings (keeping your existing code)
      if [[ -s ~/.rvm/scripts/rvm ]] ; then
        RPS1="%{$fg[yellow]%}rvm:%{$reset_color%}%{$fg[red]%}\$(~/.rvm/bin/rvm-prompt)%{$reset_color%} $EPS1"
      else
        if which rbenv &> /dev/null; then
          RPS1="%{$fg[yellow]%}rvm:%{$reset_color%}%{$fg[red]%}\$(rbenv version | sed -e 's/ (set.*$//')%{$reset_color%} $EPS1"
        fi
      fi

      ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
      ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_CLEAN=""

      # Customized git status (for outside nix-shell)
      git_custom_status() {
        local cb=$(git_current_branch)
        if [ -n "$cb" ]; then
          echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
        fi
      }

      # Get git repository name
      git_repo_name() {
        local repo_name=$(git rev-parse --show-toplevel 2>/dev/null)
        if [ -n "$repo_name" ]; then
          echo "$(basename "$repo_name")"
        else
          echo ""
        fi
      }

      # Prompt function combining repo and nix-shell info
      prompt_custom() {
        local prompt=""
        local repo_name=$(git_repo_name)

        # Add repo name if it exists
        if [ -n "$repo_name" ]; then
          prompt+="%{$fg[yellow]%}$repo_name%{$reset_color%}"
        fi

        # Add nix-shell or git branch info
        if [[ -n "$IN_NIX_SHELL" ]]; then
          # Add branch info if in a git repo
          local cb=$(git_current_branch)
          if [ -n "$cb" ]; then
            prompt+=" $(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
          fi

          if [ -z "$repo_name" ]; then
            prompt+="%{$fg[yellow]%}nix-shell%{$reset_color%} "
          fi
        else
          # Outside nix-shell, just show git branch
          prompt+="$(git_custom_status)"
        fi

        echo -n "$prompt"
      }

      # Prompt construction
      PROMPT='$(prompt_custom)%{$fg[cyan]%}[%~]%{$reset_color%}$ '
    '';
  };

  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      source /home/sheep/.zshthemes/eastwood.zsh-theme;
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
      update-ds =
        "sudo nixos-rebuild switch --flake ~/github/dotfiles/nixos#deathstar";
      update-ns =
        "sudo nixos-rebuild switch --flake ~/github/dotfiles/nixos#novastar";
    };

    oh-my-zsh = {
      enable = true;
      plugins =
        [ "git" "magic-enter" "fzf" "sudo" "tldr" "direnv" "virtualenv" ];
    };
  };
}
