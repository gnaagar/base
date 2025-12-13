# VIM usage guidelines

Normal to edit without text manipulation
- `i` : at cursor
- `a` : after cursor
- `A` : after last char in line
- `I` : first char in line

Normal to edit with text manipulation
- `c[motion]` : remove text and edit
- `C`: remove current pos to end of line, and edit
- `S/cc`: remove whole line, and edit (keep indents)
- `s`: remove current character and edit at same place
- `o`: add newline after current line and insert mode (keep indent)
- `O`: add newline before current line and insert mode (keep indent)

motions:
- `h,l`: Single char motion
- `j,k`: Single line motion
- `0,;`: Start, end of line (; is custom mapped from $)
- `f,t`: Go to/before next instance of character
- `w`: Go to next word (start) 
- `b`: Go to start of current word, or previous word if already at start
- `e`: Go to end of current word, or end of next word if already at end
- `W,B,E` : same as `w,b,e` but considers whitespace as delimiter
- G: last line

edits:
- x : delete char under cursor
- X : delete char before cursor
- `~[motion]` (use with tildeop)

Note: `_` is considered as part of word, but other special characters are not


bindings in INSERT mode:
- Most useful: <C-w> delete previous word (or till start of current word)
- <C-T>, <C-D> insert/delete indent in current line
- <C-y> insert char above the cursor (prev line)
- Too much optimization? <C-o> execute one command and return to 
  insert mode.

A sentence is defined as ending at a '.', '!' or '?' followed by either the
end of a line, or by a space or tab.  Any number of closing ')', ']', '"'
and ''' characters may appear after the '.', '!' or '?' before the spaces,
tabs or end of line.  A paragraph and section boundary is also a sentence
boundary.

- Formatting text (textwidth based): `gq[motion]`

--------------------------------


## Misc example cases

Delete all empty lines:

```
:g/^$/d
```

Run macro `a` on all lines matching pattern:

```
:g/abc/norm @a
```

How to delete all lines not containing a word `abc`
```
:v/abc/d
```

Count number of times a pattern occurs in the whole file:

```
:%s/abc//n
```

From this line to last line, surround all lines with `[]` (this example
works with surround plugin)

```
:.,$norm yss]
```

From this line to first, insert string `prefix` at the beginning:

```
:0,.norm Iprefix
```

Note: all of these commands can also run on visual selection

***

Repeat single editing action:

Examples:
- `dd`
- `2dw`
- `10I-<ESC>`

single editing actions can be repeated by `.`

This can also be applied to a visual line selection (each
line individually).

For example: to delete first 2 words of a set of lines, there are many ways:
- record macro, execute k times
- `2dw` for first line, then visual selection followed by `.`
- `.,.+5norm 2dw` (range based)

***

Scenario: add a blank line after each line in the file.

One way is macro + `g/.*/norm @a` command.

Note: For this case `:norm` won't work as that treats line range as absolute
and inserting lines change the line range.

A shorter way is `g/^/put _`
- `_` is the blackhole register which is always empty
- put inserts a new line with contents of passed register.
- without arg, it will use default register (so this way you can customize what
  you insert between each line by first copying that to a register)

***

Generate an AP

```
:r !seq 0 10 100
```


