# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEM="eastwood"




#Uncomment for OMzsh
source $ZSH/oh-my-zsh.sh


#Plugins
source ${HOME}/.zshrc.d/antigen.zsh

antigen use oh-my-zsh
#antigen bundle git
antigen bundle virtualenv
antigen bundle vi-mode
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle fzf

antigen theme eastwood
antigen apply




#z fzf
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
export BROWSER="chromium"



#vi mode
KEYTIMEOUT=.3
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

#NNN
export NNN_EDITOR="nvim"
export NNN_PLUG='t:nmount;m:mtpmount;j:autojump;d:dragdrop;x:xdgdefault;p:preview-tabbed;f:fzopen'
export NNN_FIFO="/tmp/nnn.fifo"
#export NNN_TERMINAL="alacritty --title=preview-tui"

export NNN_TERMINAL="alacritty --embed"


#Ctrl-Space
bindkey '^ ' autosuggest-accept

