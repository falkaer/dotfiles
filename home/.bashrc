#
# ~/.bashrc
#

alias sudo='sudo '
alias fuck='sudo $(fc -ln -1) '

alias bin='xdg-open ~/bin'
alias bashrc='xdg-open ~/.bashrc'
alias bspwmrc='xdg-open ~/.config/bspwm/bspwmrc'
alias sxhkdrc='xdg-open ~/.config/sxhkd/sxhkdrc'
alias config='xdg-open ~/.config'

alias venvdata='conda activate ~/venv/data'
alias discord='discord --no-sandbox'

[[ $- != *i* ]] && return

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
  esac
fi

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi
    
    if [[ $SESSION_TYPE == remote/ssh ]] ; then
		PS1='\[\e[01;31m\]λ @ \h  \W  \[\e[0m\]'
	else
		PS1='\[\e[01;33m\]λ  \W  \[\e[0m\]'
	fi
	
	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
    
    export LESS_TERMCAP_mb=$'\e[1;32m'
    export LESS_TERMCAP_md=$'\e[1;32m'
    export LESS_TERMCAP_me=$'\e[0m'
    export LESS_TERMCAP_se=$'\e[0m'
    export LESS_TERMCAP_so=$'\e[47;30m'
    export LESS_TERMCAP_ue=$'\e[0m'
    export LESS_TERMCAP_us=$'\e[1;4;35m'
    
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u @ \h  \W  \$ '
	else
		PS1='\u @ \h  \w  \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -h'                      # also human readable
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# use fish/zsh style missing line feed indicator
export PROMPT_COMMAND='printf "⏎%$((COLUMNS-1))s\\r"'

# better yaourt colors
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/falkaer/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
export LD_LIBRARY_PATH="/home/falkaer/miniconda3/lib:$LD_LIBRARY_PATH"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/falkaer/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/falkaer/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/falkaer/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

