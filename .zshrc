# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="eastwood"

#Uncomment for OMzsh
source $ZSH/oh-my-zsh.sh


#Plugins
#git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
source ${HOME}/.antidote/antidote.zsh

antidote load




#z fzf
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#aliases
alias t="tmux a"
alias vim="nvim"
alias nnn="nnn -e"

#source /etc/profile
export PATH="/home/sheep/.local/bin:$PATH"
export PATH="/home/sheep/go/bin:$PATH"
export PATH="/home/sheep/anaconda3/bin:$PATH"
export TERMINAL="alacritty --embed"


export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"



#vi mode
KEYTIMEOUT=.3
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

#NNN
export NNN_EDITOR="nvim"
export NNN_PLUG='t:nmount;m:mtpmount;j:autojump;d:dragdrop;x:xdgdefault;p:preview-tui;f:fzopen'
export NNN_FIFO="/tmp/nnn.fifo"
export NNN_TERMINAL="tmux"


#Ctrl-Space
bindkey '^ ' autosuggest-accept

# Python env
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH=$PATH:/home/sheep/.spicetify
export PATH=$PATH:/home/sheep/scripts/bin
