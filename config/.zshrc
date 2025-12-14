export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/homebrew/bin:$PATH"
export t=$HOME/workspace/scratch
export EDITOR=nvim
alias vim='nvim'

PROMPT='%(?.%F{green}%?.%F{red}%?)%f%F{yellow}%(1j. B:%j.)%f %F{white}%20>..>%M%f %F{blue}%40<..<%~%f '

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

if [[ -f "$HOME/homebrew/opt/fzf/shell/completion.zsh" ]]; then
  source "$HOME/homebrew/opt/fzf/shell/completion.zsh"
  source "$HOME/homebrew/opt/fzf/shell/key-bindings.zsh"
fi

if [[ -d "/usr/share/doc/fzf/examples" ]]; then
  source "/usr/share/doc/fzf/examples/completion.zsh"
  source "/usr/share/doc/fzf/examples/key-bindings.zsh"
fi

export FZF_COMPLETION_TRIGGER='**'

bindkey '^T' fzf-file-widget
bindkey '^R' fzf-history-widget

