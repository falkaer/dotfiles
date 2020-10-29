# turn off greeting
set -U fish_greeting

set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8

set -x XIVIEWER 'feh'
set -x PLAYER 'mpv'
set -x PAGER 'less'

set -x LESS_TERMCAP_mb \e\[1\x3B32m
set -x LESS_TERMCAP_md \e\[1\x3B32m
set -x LESS_TERMCAP_me \e\[0m
set -x LESS_TERMCAP_se \e\[0m
set -x LESS_TERMCAP_so \e\[47\x3B30m
set -x LESS_TERMCAP_ue \e\[0m
set -x LESS_TERMCAP_us \e\[1\x3B4\x3B35m

# delete next word with ctrl+delete
bind \e\[3\;5~ kill-word

set -x PATH ~/bin $PATH

function venvdata
    source /opt/intelpython3/etc/fish/conf.d/conda.fish
    conda activate ~/venv/data
end

# rerun previous command as superuser
function fuck
    eval command sudo $history[1]
end

