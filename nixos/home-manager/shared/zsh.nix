{ inputs, config, pkgs, ... }:
let
  system = pkgs.system;
  homeDir = config.home.homeDirectory;
in {

  home.file.".zshthemes/eastwood.zsh-theme" = {
    text = ''
        # RVM settings
      if [[ -s ~/.rvm/scripts/rvm ]] ; then
        RPS1="%{$fg[yellow]%}rvm:%{$reset_color%}%{$fg[red]%}\$(~/.rvm/bin/rvm-prompt)%{$reset_color%} $EPS1"
      else
        if which rbenv &> /dev/null; then
          RPS1="%{$fg[yellow]%}rbenv:%{$reset_color%}%{$fg[red]%}\$(rbenv version | sed -e 's/ (set.*$//')%{$reset_color%} $EPS1"
        fi
      fi

      ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
      ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_CLEAN=""

      # Customized git status, oh-my-zsh currently does not allow render dirty status before branch
      git_custom_status() {
        local cb=$(git_current_branch)
        if [ -n "$cb" ]; then
          echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
        fi
      }
      # nix-shell: Display nix-shell environment if running, with transparent background
      prompt_nix_shell() {
        if [[ -n "$IN_NIX_SHELL" ]]; then
          if [[ -n $NIX_SHELL_PACKAGES ]]; then
            local package_names=""
            local packages=($NIX_SHELL_PACKAGES)
            for package in $packages; do
              package_names+="'$'{package##*.}"  # No space between package names
            done
            # Transparent background and encapsulated in []
            prompt_segment NONE yellow "[$package_names]"
          elif [[ -n $name ]]; then
            local cleanName='$'{name#interactive-}
            cleanName='$'{cleanName#lorri-keep-env-hack-}
            cleanName='$'{cleanName%-environment}
            prompt_segment NONE yellow "[$cleanName]"
          else
            prompt_segment NONE yellow "[]"
          fi
        fi
      }

      # Override prompt_segment to allow transparent backgrounds
      prompt_segment() {
        local bg fg
        [[ -n $1 && $1 != 'NONE' ]] && bg="%K{$1}" || bg=""  # No background if 'NONE' is passed
        [[ -n $2 ]] && fg="%F{$2}" || fg="%f"               # Set foreground color
        if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
          echo -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"  # Removed trailing space
        else
          echo -n "%{$bg%}%{$fg%}"
        fi
        CURRENT_BG=$1
        [[ -n $3 ]] && echo -n $3
      }

      # End the prompt with no background
      prompt_end() {
        echo -n "%{%k%f%}"  # Reset both background and foreground to default
        CURRENT_BG=""
      }

      # PROMPT with correct spacing
      PROMPT='$(git_custom_status)$(prompt_nix_shell)%{$fg[cyan]%}[%~]%{$reset_color%}%B$ %b'

    '';
  };

  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      source /home/sheep/.zshthemes/eastwood.zsh-theme;
    '';
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

