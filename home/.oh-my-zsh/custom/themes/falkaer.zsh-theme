# Symbols (e.g. ➜  ❯ ↓ ● )
PROMPT_SYMBOL="❯"
PROMPT_STATUS_TRUE="%{%F{green}%}$PROMPT_SYMBOL"
PROMPT_STATUS_FALSE="%{%F{red}%}$PROMPT_SYMBOL"

BG_JOBS_SYMBOL="↓"
BG_JOBS_STATUS="%{%F{yellow}%}$BG_JOBS_SYMBOL"

# Colors
PROMPT_COLORS_USER=green
PROMPT_COLORS_HOST=blue
PROMPT_COLORS_LSB=red
PROMPT_COLORS_CURRENT_DIR=cyan
PROMPT_COLORS_GIT_STATUS_DEFAULT=green
PROMPT_COLORS_GIT_STATUS_STAGED=red
PROMPT_COLORS_GIT_STATUS_UNSTAGED=yellow
PROMPT_COLORS_BG_JOBS=yellow

# Left Prompt
PROMPT='$(_current_dir_prompt)$(_git_prompt)$(_return_status_prompt)$(_bg_jobs_prompt)%f'

# Right Prompt
RPROMPT='$(_host_prompt)%f'

# Enable redrawing of prompt variables
setopt promptsubst

_host_prompt() {
  local _user=""
  local _host=""
  local message=""
  if [[ "$LOGNAME" != "$USER" ]]; then
    # we have changed user since logging on, show current user
    _user="%{%F{$PROMPT_COLORS_USER}%}%n"
  fi
  if [[ -n "$LSB_QUEUE" ]]; then
    # we are in an interactive LSB queue, hostname doesn't really matter
    _host="%{%F{$PROMPT_COLORS_LSB}%}$LSB_QUEUE"
  elif [[ -n "$SSH_CONNECTION" ]]; then
    # we are remote, show the hostname
    _host="%{%F{$PROMPT_COLORS_HOST}%}%m"
  fi
  if [[ -n "$_user" && -n "$_host" ]]; then
    message="$_user%f@$_host"
  elif [[ -n "$_user" || -n "$_host" ]]; then
    message="$_user$_host"
  fi
  echo -n "$message"
}

_current_dir_prompt() {
  echo -n "%{%F{$PROMPT_COLORS_CURRENT_DIR}%}%c "
}

_return_status_prompt() {
  echo -n "%(?.$PROMPT_STATUS_TRUE.$PROMPT_STATUS_FALSE) "
}

_git_prompt() {
  if [[ -n "$(git_current_branch)" ]]; then
    _git_branch_prompt
    # _git_status_prompt
  fi
}

# Git prompt that just shows the branch name (fast)
_git_branch_prompt() {
  echo -n "%{%F{$PROMPT_COLORS_GIT_STATUS_DEFAULT}%}$(git_current_branch) "
}

# Git prompt that highlights the branch name based on staged/unstaged changes (slow)
_git_status_prompt() {
  local message=""
  local message_color="%F{$PROMPT_COLORS_GIT_STATUS_DEFAULT}"

  # https://git-scm.com/docs/git-status#_short_format
  local status="$(git status --porcelain 2>/dev/null)"
  local staged="$($status | grep -e "^[MADRCU]")"
  local unstaged="$($status | grep -e "^[MADRCU? ][MADRCU?]")"

  if [[ -n "$staged" ]]; then
      message_color="%F{$PROMPT_COLORS_GIT_STATUS_STAGED}"
  elif [[ -n "$unstaged" ]]; then
      message_color="%F{$PROMPT_COLORS_GIT_STATUS_UNSTAGED}"
  fi

  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ -n "$branch" ]]; then
      message+="%{$message_color%}$branch"
  fi

  echo -n "$message"
}

_bg_jobs_prompt() {
  bg_status="%(1j.$BG_JOBS_STATUS%(2j.%j.) .)"
  echo -n "$bg_status"
}

