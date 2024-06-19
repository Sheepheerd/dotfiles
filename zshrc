# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="eastwood"

plugins=(
  git
  virtualenv
)

#Uncomment for OMzsh
source $ZSH/oh-my-zsh.sh



#z fzf
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

alias t="tmux a"
alias vim="nvim"
alias nnn="nnn -e"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source /etc/profile
export PATH="/home/sheep/.local/bin:$PATH"
export PATH="/home/sheep/go/bin:$PATH"
export PATH="/home/sheep/anaconda3/bin:$PATH"
export TERMINAL="alacritty --embed"


export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="chromium"


#Ctrl-Space
bindkey '^ ' autosuggest-accept

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


source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh
