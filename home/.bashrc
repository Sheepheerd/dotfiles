
# Auto Complete
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

TEXT_WARN='\e[33m' # WARN
TEXT_ERROR='\e[31m' # Red
TEXT_DEFAULT='\e[0m' # default

function set_autorelabel () {
if [ -f "/.autorelabel" ]; then
    echo -e ${TEXT_ERROR}"System Reboot for ${HOSTNAME} required. Please reboot when convenient"${TEXT_DEFAULT}
    echo;
fi
}

function set_MOTD () {
  if [ -s /etc/motd ]; then
     echo -e ${TEXT_WARN}'Message of the Day:'${TEXT_DEFAULT}
     cat '/etc/motd'
     echo;
  fi
}

function set_WKSTMOTD () {
  if [ -s /opt/motd ]; then
    echo -e ${TEXT_WARN}'Local messages from /opt/motd:'${TEXT_DEFAULT}
    cat '/opt/motd'
    echo;
  fi
}


parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

if echo $- | grep i > /dev/null
then
  echo -e ${TEXT_WARN}"System: "${TEXT_DEFAULT}${HOSTNAME}
  echo -e ${TEXT_WARN}"Uptime: "${TEXT_DEFAULT}$(uptime | sed 's/.*up \(.*\),.*user.*/\1/')
  echo -e ${TEXT_WARN}"   CPU: "${TEXT_DEFAULT}$(lscpu | grep 'CPU(s):' | head -n1 | awk '{print $2 " threads"}')
  echo -e ${TEXT_WARN}"Memory: "${TEXT_DEFAULT}$(free -h | awk 'NR==2{printf "%s/%s (%.2f%%)\n", $3,$2,$3*100/$2 }')
  echo -e ${TEXT_WARN}" Users: "${TEXT_DEFAULT}$(who | awk '!seen[$1]++ {printf $1 " "}')
  echo;
  set_autorelabel
  set_MOTD
  set_WKSTMOTD
fi

export PS1="\[\033[1;32m\]\u@\[\e[33m\]\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ "


#export PS1='[\u@\h \w]\$ '
#if [[ -f /.dockerenv ]]
#the
#  PS1="[\u@${TEXT_WARN}\h${TEXT_DEFAULT} \w]\$ "
#fi

#java
export JAVA_HOME="${HOME}/.local/share/java-22-openjdk"
export MAVEN_HOME="${HOME}/.local/share/apache-maven"
export PATH="${HOME}/.local/share/java-22-openjdk/bin:${PATH}"
export PATH="${HOME}/.local/share/apache-maven/bin:${PATH}"

export TZ=EDT
export PATH_ORIG=${PATH}
export PATH="${HOME}/scripts:${PATH}"
export PATH="${HOME}/.local/bin:${PATH}"
#export PATH="${HOME}/scripts:${HOME}/.local/bin:/usr/local/bin:${PATH}:${HOME}/go-1.21.1/bin"
#export LD_LIBRARY_PATH="${HOME}/.local/lib64:${LD_LIBRARY_PATH}"

# bash history
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoreboth
export HISTSIZE=-1
export HISTFILESIZE=-1
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Source Bash completion definitions for tab completion on commands
alias ..='cd ..'
alias vim='nvim'
alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias df="df -h"
alias vi="vim"
alias dnfvar="/usr/libexec/platform-python -c 'import dnf, json; db = dnf.dnf.Base(); print(json.dumps(db.conf.substitutions, indent=2))'"

# docker
alias dps='docker ps --all --format="table {{.Names}}\t{{.Ports}}\t{{.Status}}"'
alias drm=fdrm
alias drmi=fdrmi
alias dim='docker images --format="table {{.Repository}}:{{.Tag}}\t{{.CreatedSince}}\t{{.Size}}" --filter "dangling=false" | tail -n +2 | sort'
alias dip="docker inspect --format='{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "

# git
alias gst="git status"
alias gco="git checkout"
alias gcm="git commit -am"
alias gpl="git pull --prune"
alias gps="git push"
alias gcl="git clone"
alias grh="git reset --hard"
alias grs="git reset --soft"
alias gf="git fetch --prune"
alias gl='git log --pretty=format:"%h %ad %s" -n 1000 --date=short --graph'
alias gd="git diff"

if [[ -f ${HOME}/.config/git_bash_completion ]]
then
  . ${HOME}/.config/git_bash_completion

  __git_complete gst _git_status
  __git_complete gco _git_checkout
  __git_complete gcm _git_commit
  __git_complete gpl _git_pull
  __git_complete gps _git_push
  __git_complete gcl _git_clone
  __git_complete grh _git_reset
  __git_complete grs _git_reset
  __git_complete gf _git_fetch
  __git_complete gl _git_log
  __git_complete gd _git_diff
fi

function fdrm {
  if [[ -n "${1}" ]]
  then
    names=${*}
  else
    names=$(docker ps --filter "status=exited" --filter "status=created" --format "{{.Names}}")
  fi
  if [[ -n "${names}" ]]
  then
    docker rm -f ${names}
  fi
}

function fdrmi {
  local names=${1:-*}

  matches=$(docker images | tail -n +2 | grep -E -- "${names}" | awk '/<none>/ { print $3; next } { printf("%s:%s\n",$1,$2)}')
  if [[ -z "${matches}" ]]
  then
    echo "No matching images found"
    return 1
  fi

  docker rmi ${matches}
}


# Shepards Add ons

# Use bash-completion, if available
[[ $PS1 && -f ${HOME}/.local/share/bash-completion/bash_completion ]] && \
    . ${HOME}/.local/share/bash-completion/bash_completion



[ -f ~/.fzf.bash ] && source ~/.fzf.bash

shopt -s autocd cdspell direxpand dirspell globstar histappend histverify \
    nocaseglob no_empty_cmd_completion

source $HOME/.fzf-tab-completion/bash/fzf-bash-completion.sh
bind -x '"\C-f": fzf_bash_completion'

# Vim mode
set -o vi

set ttimeoutlen 2

if [ ! -z ${SIMPLE_ZSH_NIX_SHELL_BASH+x} ] ;
  then source $SIMPLE_ZSH_NIX_SHELL_BASH
fi
