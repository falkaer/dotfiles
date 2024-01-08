# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="falkaer"

# How often to auto-update (in days).
zstyle ':omz:update' frequency 7

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git zsh-history-substring-search zsh-autosuggestions zsh-syntax-highlighting colored-man-pages)

if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  . "$ZSH/oh-my-zsh.sh"
fi

# broot cd workaround
source "$HOME/.config/broot/launcher/bash/br"

# customize termcap colors (for less, must be sourced after OMZ)
# bold and blinking modes
less_termcap[mb]="${fg_bold[red]}"
less_termcap[md]="${fg_bold[green]}" 
less_termcap[me]="${reset_color}"
# standout mode
less_termcap[so]="${fg_bold[black]}${bg[white]}"
less_termcap[se]="${reset_color}"
# underlining
less_termcap[us]="${fg_bold[cyan]}"
less_termcap[ue]="${reset_color}"

. "$HOME/.aliases"

source "$HOME/.config/broot/launcher/bash/br"
