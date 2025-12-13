" --------------------------------
" Author: terxor
" License: The MIT License (MIT)
" 
" `xv3_dark` theme (gui only)
" --------------------------------
" Hint: Type :hi to debug colors

let g:inherit_termbg = 1

set background=dark
highlight clear
syntax reset

" --- Dark Theme Color Palette ---

" Backgrounds / Grays
let s:bg           = "234"  " Dark Grey Background
let s:fg           = "252"  " Light Grey Foreground
let s:black        = "232"
let s:off_white    = "236"  " Slightly lighter BG (for splits)
let s:grey         = "245"
let s:grey2        = "240"
let s:faded        = "243"  " Comments/Ignored
let s:grey_alt     = "239"

" Accents (Lighter/Pastel for Dark BG)
let s:red          = "203"  " Soft Red
let s:green        = "114"  " Pale Green
let s:blue         = "110"  " Sky Blue
let s:lblue        = "62"   " Selection Blue
let s:purple       = "176"  " Lavender
let s:yellow       = "222"  " Light Gold
let s:orange4      = "215"  " Soft Orange
let s:teal         = "73"

" Specific UI Colors
let s:warn_bg      = "58"   " Dark Brown/Yellow for warnings
let s:warn_fg      = "220"  " Bright Gold
let s:search_bg    = "221"  " Bright Yellow for search matches
let s:search_fg    = "232"  " Black text on search matches

" Diffs
let s:b_green      = "22"   " Dark Green BG (Diff Add)
let s:b_red        = "52"   " Dark Red BG (Diff Delete)
let s:b_yellow     = "237"  " Dark Grey BG (Diff Change / Pmenu)
let s:gold         = "221"  " Pmenu Sel

" Unused/Legacy placeholders mapped to safe defaults
let s:alt_green    = "106"
let s:brown        = "131"
let s:dark_brown   = "52"
let s:dark_green   = "70"
let s:lgrey        = "252"
let s:lgrey2       = "250"
let s:almostwhite  = "255"
let s:unset        = "10"
let s:amber        = "220"
let s:mistyrose    = "224"
let s:lpurple      = "189"
let s:alt_purple   = "60"
let s:lcyan        = "195"
let s:dsgreen      = "193"
let s:dsgrey       = "123"
let s:almostwhite2 = "15"
let s:ygreen       = "192"
let s:yellow2      = "226"
let s:green2       = "157"
let s:dblue        = "25"

let s:bold = "bold"
let s:none = "none"


function! HgS(group, fg, bg, style)
  let cmd = "highlight " . a:group
  if a:fg != ""
    let cmd .= " ctermfg=" . a:fg
  endif
  if a:bg != ""
    let cmd .= " ctermbg=" . a:bg
  endif
  if a:style != ""
    " let cmd .= " gui=" . a:style
    let cmd .= " cterm=" . a:style
  else
    " let cmd .= " gui=none"
    let cmd .= " cterm=none"
  endif
  execute cmd
endfunction

function! HgF(group, guifg)
  call HgS(a:group, a:guifg, "", "")
endfunction

function! HgB(group, guibg)
  call HgS(a:group, "", a:guibg, "")
endfunction

if g:inherit_termbg
  call HgS("Normal", s:fg, "", s:none)
else
  call HgS("Normal", s:fg, s:bg, s:none)
endif

call HgS("StatusLine", s:fg, "", s:bold) 
call HgS("StatusLineNC", s:grey, "", "")
call HgS("CursorLine",   "", "", "") " Added slight highlight for cursor line
call HgS("CursorLineNr", s:red, "", s:bold)
call HgS("VertSplit", s:grey_alt, s:bg, "") 

call HgF("Comment", s:faded) " Changed from Red to Faded Grey for Dark Theme standard, swap to s:red if you prefer red comments
call HgF("Keyword", s:purple)
call HgF("String", s:green)
call HgF("Number", s:yellow)
call HgF("Type", s:blue)          
call HgF("Function", s:blue)      
call HgF("Identifier", s:blue)    
call HgF("Constant", s:blue)      
call HgF("Statement", s:blue)     
call HgF("PreProc", s:purple)
call HgB("MatchParen", s:grey_alt)
call HgS("Todo", s:black, s:yellow, s:bold)
call HgF("LineNr", s:grey_alt)
call HgS("Visual", "", s:lblue, "")
call HgF("Title", s:red)
call HgS("Search", s:search_fg, s:search_bg, "")
call HgS("CurSearch", s:search_fg, s:search_bg, s:bold)
" call HgB("EndOfBuffer", s:bg)

call HgF("xv3_CodeBlock", s:blue)
call HgS("xv3_BoldTitle", s:red, "", s:bold)
call HgF("xv3_Code", s:purple)
call HgF("xv3_Faded", s:faded)
call HgF("xv3_Grey", s:grey_alt)
call HgF("xv3_WarnFg", s:warn_fg)
call HgS("xv3_Warn", "", s:warn_bg, "")

call HgS("DiffAdd", s:green, s:b_green, "")
call HgS("DiffDelete", s:b_red, s:b_red, s:none)
call HgS("DiffChange", "", s:b_yellow, "")
call HgS("DiffText", s:orange4, s:b_yellow, "")

" call HgS("SignColumn", "", s:bg, "")
call HgS("FoldColumn", s:grey, s:bg, s:none)
call HgS("Folded", s:grey, s:bg, s:none)

" hi link FoldColumn Normal
" hi link SignColumn Normal

call HgS("Pmenu", s:fg, s:b_yellow, s:none)
call HgS("PmenuSel", s:black, s:gold, s:bold)

hi link markdownH1                Title
hi link markdownCodeBlock         xv3_CodeBlock
hi link markdownCode              xv3_Code
hi link markdownHeadingDelimiter  xv3_Faded
hi link markdownRule              xv3_Faded
hi link markdownBlockquote        String
" disable em and strong to prevent unintended styling
hi link markdownEmphasis          Normal
hi link markdownStrong            Normal
hi link markdownBold              Normal
hi link markdownItalic            Normal
hi link markdownLongLine          xv3_Grey
" Set errors to normal, avoid noise due to underscores mainly
hi link markdownError             Normal

set fillchars=eob:\ ,vert:\  " Note: space
