export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/homebrew/bin:$PATH"

export EDITOR=nvim
alias v='nvim'

export t=$HOME/workspace/scratch/tmpbuf

PROMPT='%(?.%F{green}OK.%F{red}FAIL)%f %F{blue}%~%f %F{yellow}%(1j. (bg:%j).)%f
'

setopt HIST_IGNORE_ALL_DUPS

autoload -Uz compinit
compinit

source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:*' fzf-flags --color=light
fzf-history() {
  local result=$(fc -lnr 1 | fzf --height 40% --layout=reverse --query="$LBUFFER")
  if [ -n "$result" ]; then
    BUFFER="$result"
    CURSOR=$#BUFFER
  fi
  zle reset-prompt
}
zle -N fzf-history
bindkey '^R' fzf-history

