{ pkgs, ... }: {
  programs = {
    eza = {
      enable = true;
      enableFishIntegration = true;

    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    bash = {
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';

    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;
      shellAliases = {
        t = "tmux a";
        open = "xdg-open";
        vim = "nvim";
        fd = "zoxide";
        update-ds =
          "sudo nixos-rebuild switch --flake ~/github/dotfiles/nixos#deathstar";
        update-ns =
          "sudo nixos-rebuild switch --flake ~/github/dotfiles/nixos#novastar";
        uhm-ds = "home-manager switch --flake .#sheep@deathstar";
        uhm-ns = "home-manager switch --flake .#sheep@novastar";
      };
      shellInit = ''

        bind ctrl-space accept-autosuggestion
        set --erase fish_greeting
      '';
      functions = { fish_greeting = ""; };
      plugins = [
        {
          name = "clearance";
          src = pkgs.fetchFromGitHub {
            owner = "Sheepheerd";
            repo = "eastwood-fish";
            rev = "1c61a1b8e55156b58ec3e72ba817311618a97679";
            hash = "sha256-9UMLXpor0OuQy7L94dEQgO6L2cBxANuGSD5N/b5s1DQ=";
          };
        }
        {
          name = "git";
          src = pkgs.fetchFromGitHub {
            owner = "jhillyerd";
            repo = "plugin-git";
            rev = "d6950214b6b2392d3dbb2cb670f2a5f240090038";
            hash = "sha256-0uEKw+7EXkf5u3p3hfthSfQO/2rr3wl35ela7P2vB0Q=";
          };
        }
      ];

    };
  };

}
