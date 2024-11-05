
{inputs, pkgs, ... }:
{


programs.zsh = {
enable = true;
enableCompletion = true;
autosuggestions.enable = true;
syntaxHighlighting.enable = true;

shellInit =''
bindkey '^ ' autosuggest-accept

eval "$(zoxide init zsh)"
'';

shellAliases = {
    t = "tmux a";
open="xdg-open";
vim="nvim";
fd="zoxide";
update = "sudo nixos-rebuild switch";
  };

  ohMyZsh = {
    enable = true;
    plugins = [  "git" "magic-enter" "fzf" "pyenv" "sudo" "tldr" ];
    theme = "eastwood";
  };
};
}
