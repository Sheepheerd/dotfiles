
{inputs, pkgs, ... }:
{


programs.zsh = {
enable = true;
enableCompletion = true;
autosuggestions.enable = true;
syntaxHighlighting.enable = true;

shellInit =''
bindkey '^ ' autosuggest-accept
'';

shellAliases = {
    t = "tmux a";
open="xdg-open";
vim="nvim";
fd="z";
update = "sudo nixos-rebuild switch";
  };

  oh-my-zsh = {
    enable = true;
    plugins = [  "git" "magic-enter" "fzf" "pyenv" "sudo" "tldr" ];
    theme = "eastwood";
  };
};
}
