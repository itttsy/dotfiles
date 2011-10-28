" vim color file
" Maintainer:  Tekkan Aira <whtrix@gmail.com>
" Last Modified: 2011/03/04 10:24AM
" Version: 0.9
"
" Miku is minimal color scheme.
" Disigned to work equally well on 8 or 16 colors, terminal or gui.

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "miku"

hi Normal       term=none                 ctermfg=7  ctermbg=0  gui=none      guifg=#f8f8f8 guibg=#000000
hi Directory    term=bold      cterm=bold ctermfg=10                          guifg=#40e0d0
hi Search       term=reverse              ctermfg=7  ctermbg=2                guifg=#d3d3d3 guibg=#2e8b57
hi MoreMsg      term=none      cterm=bold ctermfg=2             gui=bold      guifg=#2e8b57
hi ModeMsg      term=bold      cterm=bold ctermfg=0  ctermbg=2  gui=bold      guifg=#fffafa guibg=#000000
hi LineNr       term=underline cterm=bold ctermfg=3                           guifg=#008b8b
hi CursorLine   term=none      cterm=none                       gui=none                    guibg=#0f1f1f
hi Question     term=standout  cterm=bold ctermfg=2             gui=bold      guifg=#006400
hi Comment      term=bold      cterm=bold ctermfg=14            gui=none      guifg=#ffd700
hi Constant     term=bold      cterm=none ctermfg=7             gui=none      guifg=#d3d3d3
hi Special      term=bold      cterm=none ctermfg=2             gui=none      guifg=#40e0d0
hi Identifier   term=none      cterm=none ctermfg=7             gui=none      guifg=#d3d3d3
hi PreProc      term=underline cterm=bold ctermfg=15            gui=bold      guifg=#fffafa
hi Error        term=reverse   cterm=bold ctermfg=8  ctermbg=0  gui=bold      guifg=#ff0000 guibg=#000000
hi Todo         term=standout  cterm=none ctermfg=0  ctermbg=15               guifg=#000000 guibg=#fffafa
hi String       term=none      cterm=none ctermfg=10            gui=none      guifg=#7fffd4
hi Function     term=bold      cterm=bold ctermfg=2             gui=none      guifg=#40e0d0
hi Statement    term=bold      cterm=bold ctermfg=15            gui=bold      guifg=#fffafa
hi Include      term=bold      cterm=bold ctermfg=11            gui=none      guifg=#add8e6
hi Type         term=none      cterm=none ctermfg=13            gui=none      guifg=#00ff7f
hi Defined      term=bold      cterm=bold ctermfg=3             gui=none      guifg=#e0ffff
hi DiffAdd      term=reverse                         ctermbg=1                              guibg=#2f4f4f
hi DiffChange   term=reverse                         ctermbg=8                              guibg=#a9a9a9
hi DiffDelete   term=reverse                         ctermbg=4  gui=bold                    guibg=#dc143c
hi DiffText     term=reverse   cterm=bold ctermfg=12 ctermbg=8  gui=bold      guifg=#ff0000 guibg=#a9a9a9
hi StatusLine   term=none      cterm=bold ctermfg=0  ctermbg=3  gui=none      guifg=#0f2f2f guibg=#8fbc8f
hi VertSplit                                                    gui=none      guifg=#000000 guibg=#8fbc8f
hi FoldColumn                                                   gui=none      guifg=#000000 guibg=#2e8b57
hi Pmenu        term=none      cterm=none ctermfg=7  ctermbg=3                guifg=#000000 guibg=#20b2aa
hi PmenuSel     term=none      cterm=none ctermfg=7  ctermbg=0                guifg=#20b2aa guibg=#000000
hi link Character       String
hi link Number          Constant
hi link Boolean         Constant
hi link Float           Number
hi link Conditional     Statement
hi link Repeat          Statement
hi link Label           Statement
hi link Operator        Statement
hi link Keyword         Statement
hi link Exception       Statement
hi link Macro           Include
hi link PreCondit       PreProc
hi link StorageClass    Type
hi link Structure       Type
hi link Typedef         Type
hi link Tag             Special
hi link SpecialChar     Special
hi link Delimiter       Special
hi link SpecialComment  Special
hi link Debug           Special

