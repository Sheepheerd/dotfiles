export ZSH="$HOME/.oh-my-zsh"


# GOAT Theme
ZSH_THEME="eastwood"

plugins=(
  git
  zsh-syntax-highlighting
  virtualenv
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh



#z fzf
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

alias t="tmux a"
alias vim="nvim"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source /etc/profile
export PATH="/home/sheep/.local/bin:$PATH"
export PATH="/home/sheep/go/bin:$PATH"


export EDITOR="nvim"
export VISUAL="nvim"


#Ctrl-Space
bindkey '^ ' autosuggest-accept

#vi mode
KEYTIMEOUT=.3
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search
