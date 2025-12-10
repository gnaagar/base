#!/bin/zsh

# Favourite words/strings utility
# Usage: press ctrl+f while entering a command to get a searchable list
# of words

FVWORDS=$ZDOTDIR/.fvlist

fvwords() {
  local word="$(cat $FVWORDS | fzf)"

  if [[ -n "$word" ]]; then
    local pre_cursor="${BUFFER:0:$CURSOR}"
    local post_cursor="${BUFFER:$CURSOR}"
    BUFFER="$pre_cursor$word$post_cursor"
    CURSOR=$(( ${#pre_cursor} + ${#word} ))
  fi
  zle redisplay
}

fvadd() {
  if [[ -n "$1" ]]; then
    tmpfile=$(mktemp)
    cp $FVWORDS $tmpfile
    echo "$1" >> $tmpfile
    sort $tmpfile -o $FVWORDS
    echo "Added $1"
  else
    echo "Nothing to add"
  fi
}


zle -N fvwords
bindkey '^f' fvwords

