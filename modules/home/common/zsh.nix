{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.solarsystem.modules.zsh;
  homeDir = config.home.homeDirectory;
in
{
  options.solarsystem.modules.zsh = lib.mkEnableOption "Custom Zsh config with fzf, zsh theme, and plugins";

  config = lib.mkIf cfg {
    programs.fzf.enable = true;
    programs.fzf.enableZshIntegration = true;

    # Place custom zsh theme in the user's home directory dynamically
    home.file.".zshthemes/eastwood.zsh-theme" = {
      text = ''
        # Python virtual environment detection
        prompt_python_env() {
          if [[ -n "$VIRTUAL_ENV" ]]; then
            prompt_segment NONE magenta "[venv]"
          elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
            prompt_segment NONE magenta "[conda:$CONDA_DEFAULT_ENV]"
          fi
        }

        # rbenv support
        if command -v rbenv &> /dev/null; then
          RPS1="%{$fg[yellow]%}rbenv:%{$reset_color%}%{$fg[red]%}\$(rbenv version | sed -e 's/ (set.*$//')%{$reset_color%} $EPS1"
        fi

        ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
        ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
        ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
        ZSH_THEME_GIT_PROMPT_CLEAN=""

        # Customized git status
        git_custom_status() {
          local cb=$(git_current_branch)
          if [ -n "$cb" ]; then
            echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
          fi
        }

        # nix-shell: Display nix-shell environment if running
        prompt_nix_shell() {
          if [[ -n "$IN_NIX_SHELL" ]]; then
            if [[ -n $NIX_SHELL_PACKAGES ]]; then
              local package_names=""
              local packages=($NIX_SHELL_PACKAGES)
              for package in $packages; do
                package_names+="'$\{package##*.}"
              done
              prompt_segment NONE yellow "[$package_names]"
            elif [[ -n $name ]]; then
              # local cleanName="$\{name#interactive-}"
              # cleanName="$\{cleanName#lorri-keep-env-hack-}"
              # cleanName="$\{cleanName%-environment}"
              prompt_segment NONE yellow "[nix]"
            else
              prompt_segment NONE yellow "[]"
            fi
          fi
        }

        # Transparent prompt segments
        prompt_segment() {
          local bg fg
          [[ -n $1 && $1 != 'NONE' ]] && bg="%K{$1}" || bg=""
          [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
          if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
            echo -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
          else
            echo -n "%{$bg%}%{$fg%}"
          fi
          CURRENT_BG=$1
          [[ -n $3 ]] && echo -n $3
        }

        # Reset prompt colors
        prompt_end() {
          echo -n "%{%k%f%}"
          CURRENT_BG=""
        }

        # PROMPT with git, nix-shell, and python environment
        PROMPT='$(git_custom_status)$(prompt_nix_shell)$(prompt_python_env)%{$fg[cyan]%}[%~]%{$reset_color%}%B$ %b'

      '';
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initContent = ''
        source ${homeDir}/.zshthemes/eastwood.zsh-theme
        bindkey '^ ' autosuggest-accept
        export PATH="$PATH:$HOME/.scripts/bin"
        export PATH="$PATH:$HOME/.local/bin"
        eval "$(zoxide init zsh)"
      '';

      shellAliases = {
        t = "tmux a";
        open = "xdg-open";
        vim = "nvim";
        ls = "eza";
        cat = "bat";
        grep = "rg";

        update-d = "sudo nixos-rebuild switch --flake ~/.dotfiles#deathstar";
        update-n = "sudo nixos-rebuild switch --flake ~/.dotfiles#novastar";
        update-s = "sudo nixos-rebuild switch --flake ~/.dotfiles#solis";

        # school related
        fry = "ssh w947sxg@fry.cs.wright.edu";
      };

      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];

      oh-my-zsh = {
        enable = true;
        # theme = "eastwood"; # You can enable this if you want to use oh-my-zsh's theme system
        plugins = [
          "git"
          "magic-enter"
          "fzf"
          "sudo"
          "tldr"
          "direnv"
          "virtualenv"
        ];
      };
    };
  };
}
