source $ZDOTDIR/custom_pre.zsh
# --------------------------------
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.homebrew/bin:$PATH"
export EDITOR=nvim
export THEME="dark" # For vim and certain parts in this file

# QOL
export workspace=$HOME/workspace
export scratch=$workspace/scratch
export t=$scratch/tmpbuf

# --------------------------------
# oh-my-zsh
# --------------------------------
ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

DISABLE_AUTO_UPDATE=true
zstyle ':omz:update' mode disabled

plugins=(
  vi-mode # always keep first, otherwise it breaks fzf and fzf-tab
  git
  fzf
  fzf-tab
)

if [[ "$ZSH_TMUX_AUTOSTART" = true ]]; then
  plugins+=(tmux)
fi

source $ZSH/oh-my-zsh.sh

if [[ "$THEME" = "light" ]]; then
  ':fzf-tab:*' fzf-flags --color=light
fi

# --------------------------------
# general
# --------------------------------

bindkey '^P' push-line

setopt magic_equal_subst

# Makes esc work without delay in vi-mode
KEYTIMEOUT=1

bindkey -M vicmd ';'  end-of-line
bindkey -M viins '^H' backward-kill-word

build_prompt() {
  local _vcs="${1:-\$(git_prompt_info)}"
  local _status _path _jobs _vi

  _status='%(?.%F{green}OK.%F{red}FAIL)%f'
  _path='%F{blue}%~%f'
  _jobs='%F{yellow}%(1j. (bg:%j).)%f'
  _vi='%F{white}$(vi_mode_prompt_info)%f'

  _nl=$'\n'
  printf "%s %s%s %s %s%s%%" "$_status" "$_path" "$_jobs" "$_vcs" "$_vi" "$_nl"
}

PROMPT="$(build_prompt)"

RPROMPT=""
MODE_INDICATOR="-- NORMAL --"
# Better colors for fzf results
if [[ "$THEME" = "light" ]]; then
  FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=light'
fi

# --------------------------------
# aliases
# --------------------------------

alias py='python3'

# git diff aliases to use vimdiff
alias gd="git difftool"
alias gds="git difftool --staged"

# git status of multiple repositories under a dir
alias gitstat='find . -maxdepth 1 -mindepth 1 -type d -exec sh -c "(echo {} && cd {} && git status -s && echo)" \;'

# show dotfiles/dirs by default but ignore .git
alias tree='tree -a -I .git'

alias vd='nvim -d'

# --------------------------------
# utils
# --------------------------------

source $ZDOTDIR/fv.zsh
source $ZDOTDIR/custom_post.zsh

# --------------------------------
# standard utils lib
# --------------------------------
local UTILS_PY_DIR=$HOME/workspace/base/utils/py
if [[ -d "$UTILS_PY_DIR" ]]; then
  export PYTHONPATH="${PYTHONPATH:+$PYTHONPATH:}$UTILS_PY_DIR"
fi

# tmpbuf related

insert_first_empty_buffer() {
    # local buf
    # buf=$(t -f | awk '{print $1}')
    # zle -U "\$t/$buf"

    buffers=(${(z)$(t -f)})  # split into words
    (( ${#buffers[@]} )) || return  # exit if empty

    # shuffle and pick first
    buf=${buffers[RANDOM % ${#buffers[@]} + 1]}  # Zsh arrays are 1-based
    zle -U "\$t/$buf"
}
zle -N insert_first_empty_buffer

# Bind to Ctrl-T
bindkey '^T' insert_first_empty_buffer

