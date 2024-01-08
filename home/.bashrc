# do nothing if not interactive
[[ $- != *i* ]] && return

PS1='\[\e[01;33m\]λ  \W  \[\e[0m\]'

export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[47;30m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;35m'
    
complete -cf sudo
shopt -s checkwinsize
shopt -s expand_aliases
shopt -s histappend

# broot cd workaround
source "$HOME/.config/broot/launcher/bash/br"

. "$HOME/.aliases"
