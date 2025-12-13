export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/homebrew/bin:$PATH"
export t=$HOME/workspace/scratch/tmpbuf
export EDITOR=nvim
alias v='nvim'

bindkey -v

zle-keymap-select() {
  MODE=$([[ $KEYMAP == vicmd ]] && print '%F{white}-- NORMAL --%f')
  zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-line-init zle-keymap-select

KEYTIMEOUT=1
setopt PROMPT_SUBST

PROMPT='%(?.%F{green}OK.%F{red}FAIL)%f %F{blue}%~%f %F{yellow}%(1j. (bg:%j).)%f ${MODE}
'

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt \
  APPEND_HISTORY \
  INC_APPEND_HISTORY \
  SHARE_HISTORY \
  HIST_IGNORE_DUPS \
  HIST_IGNORE_ALL_DUPS \
  HIST_REDUCE_BLANKS

autoload -Uz compinit
compinit

source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:*' fzf-flags --color=light

if [[ -f "$HOME/homebrew/opt/fzf/shell/completion.zsh" ]]; then
  source "$HOME/homebrew/opt/fzf/shell/completion.zsh"
  source "$HOME/homebrew/opt/fzf/shell/key-bindings.zsh"
fi

export FZF_COMPLETION_TRIGGER='**'

bindkey -M viins '^T' fzf-file-widget
bindkey -M viins '^R' fzf-history-widget

