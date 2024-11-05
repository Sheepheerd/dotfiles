# If you come from bash, you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="eastwood"

# Load Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# Antidote plugin manager
# Uncomment to install Antidote if not already done
# git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
source "$HOME/.antidote/antidote.zsh"
antidote load

# Lazy load FZF and Z integration
autoload -Uz add-zsh-hook
fuzzy_load() {
    [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
}
add-zsh-hook precmd fuzzy_load

[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh


# Environment Variables
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/anaconda3/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:$HOME/android-sdk/platform-tools"
export PATH="$PATH:$HOME/.spicetify"
export PATH="$PATH:$HOME/.scripts/bin"
export PATH="$PATH:$HOME/.modular/bin"
export PATH="$PATH:$HOME/.modular/pkg/packages.modular.com_mojo/bin"

# Terminal settings
export TERMINAL="alacritty --embed"
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"
export LIBVIRT_DEFAULT_URI="qemu:///system"
export LD_LIBRARY_PATH="$HOME/.local/lib/arch-mojo:$LD_LIBRARY_PATH"
