" vim:set ts=4 sts=4 sw=4 tw=0: (この行に関しては:help modelineを参照)
if !exists('g:loaded_vimrc')
    let g:loaded_vimrc = 0
endif

" <Leader>に'\'の代わりに'm'を使えるようにする
let mapleader = 'm'
let g:mapleader = 'm'
let g:maplocalleader = ','
" <Leader>.で即座にvimrcを開けるようにする
nnoremap <Leader>. :<C-u>edit $MYVIMRC<CR>
" :ReloadVimrcコマンドの追加
command! ReloadVimrc  source $MYVIMRC

" 初期設定 {{{
set nocompatible
filetype plugin indent on
if has('win32') || has('win64')
    set shellslash
endif
call altercmd#load()
" Plug-inのためにキーマップを開放する
nnoremap ; <NOP>
xnoremap ; <NOP>
nnoremap m <NOP>
xnoremap m <NOP>
nnoremap , <NOP>
xnoremap , <NOP>
" }}}

"-- 
" 日本語用エンコード設定{{{
set encoding=Japan
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp

" modeline内にfencを指定されている場合の対応 {{{
let s:oldlang=v:lang
function! s:DoModelineFileEncoding()
    if &modified == 0 || &fileencoding == '' || v:cmdbang
        return
    endif
    silent lang mes C
    redir => line
    silent verbose set fenc?
    redir END
    exe "lang mes ".s:oldlang
    if split(line, "\n")[-1] =~ "modeline"
        exe "edit! ++bad=keep ++enc=".&fileencoding
        doautocmd BufEnter
    endif
endfunction

augroup ModelineFileEncoding
    autocmd!
    autocmd BufEnter * silent call <SID>DoModelineFileEncoding()
augroup END
" }}}
" }}}

"-- 
" プラットフォーム依存の問題の為の設定 {{{
" Windows/Linuxにおいて、.vimと$VIM/vimfilesの違いを吸収する {{{
if has('win32') || has('win64')
    let $DOTVIM = $VIM."/vimfiles"
else
    let $DOTVIM = $HOME."/.vim"
endif
" }}}

" ファイル名に大文字小文字の区別がないシステム用の設定 {{{
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
    set tags=./tags,tags
endif
" }}}

" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応 {{{
if !has('gui_running') && has('xterm_clipboard')
    set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif
" }}}

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正 {{{
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
    let $PATH = $VIM . ';' . $PATH
endif
" }}}

" Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正 {{{
if has('mac')
    set iskeyword=@,48-57,_,128-167,224-235
endif
" }}}

" helptagsの生成 {{{
if has('mac')
    helptags ~/.vim/doc/
elseif has('win32')
    helptags ~/vimfiles/doc/
endif
" }}}
" }}}

"-- 
" GUI固有ではない画面表示の設定 {{{
set wrap
set showmode
set showmatch
set number
set noruler

" title {{{
set title
set statusline=
    \%<%{expand('%:p')}\ %m%r%h%w
    \%=%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}[%{tabpagenr()}/%{tabpagenr('$')}]\ %P
" }}}

" statusline {{{
set showtabline=0
set laststatus=2
set cmdheight=1
set showcmd
" }}}

" gui {{{
set t_Co=256
set visualbell
set norestorescreen
set t_ti=
set t_te=
" }}}

" cursor {{{
set cursorline
set backspace=2
" }}}

" listchars {{{
set list
set listchars=tab:>_,extends:>,precedes:<,eol:_,trail:~
" }}}

" fillchars {{{
set fillchars=stl:\ ,stlnc::,vert:\ ,fold:-,diff:-
" }}}

" scroll {{{
set scroll=5
set scrolloff=9999
" }}}

" case arc {{{
set showmatch
set cpoptions-=m
set matchtime=3
set matchpairs+=<:>
" }}}

" fold {{{
set foldenable
set foldmethod=marker
set foldcolumn=3
" 行頭で h を押すと選択範囲に含まれる折畳を閉じる
vnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
" 折畳上で l を押すと選択範囲に含まれる折畳を開く
vnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'

" 現在のfoldのみ開いた状態にする
func! s:fold_current_expand()
    silent! %foldclose!
    normal! zvzz
endfunc
nnoremap z<Space>   :call <SID>fold_current_expand()<CR>
" }}}

" misc {{{
set diffopt=filler,vertical
set helplang=ja,en
set nojoinspaces
" }}}
" }}}

"-- 
" マウスに関する設定 {{{
set mouse=a
" }}}

"-- 
" 編集に関する設定 {{{
" indent {{{
set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=4
set shiftround
set shiftwidth=4
" }}}

" completion {{{
set complete+=k
set wildmenu
set wildchar=<Tab>
set wildignore=*.o,*.obj,*.la,*.a,*.exe,*.com,*.tds
set pumheight=20
" }}}

" swap {{{
set noswapfile
set updatecount=0
if has('unix')
    set nofsync
    set swapsync=
endif
" }}}

" backup {{{
set backup
set backupdir=~/vimfiles/backup
" }}}

" misc {{{
set hidden
set formatoptions& formatoptions+=mM
set nrformats& nrformats-=octal
set virtualedit+=block
set grepprg=internal
set clipboard& clipboard+=unnamed,autoselect
set isfname& isfname+=32
nnoremap Y y$
inoremap <expr> ] searchpair('\[', '', '\]', 'nbW', 'synIDattr(synID(line("."), col("."), 1), "name") =~? "String"') ? ']' : "\<C-n>"
augroup DictFile
    autocmd!
    autocmd FileType *  execute printf("setlocal dict=~/vimfiles/dict/%s.dict", &filetype)
augroup END
command! -nargs=+ -bang -complete=file Rename let pbnr=fnamemodify(bufname('%'), ':p')|exec 'f '.escape(<q-args>, ' ')|w<bang>|call delete(pbnr)
" }}}

" 内容が空の.txtファイルを保存したら自動で削除する {{{
augroup BUFWRITE_POSTDELETE
    autocmd!
    autocmd BufWritePost *.txt call BufWritePostDelete()
augroup END

function! BufWritePostDelete()
    let crlen = 0
    if &binary == 0
        let crlen = &ff=='dos' ? 2 : 1
    endif
    if getfsize(expand('%:p')) <= crlen
        call delete(expand('%:p'))
    endif
endfunction
" }}}
" }}}

"-- 
" 検索の挙動に関する設定 {{{
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan
nmap n nzz
nmap N Nzz
nnoremap <silent> f :set iminsert=0<CR>f
nnoremap <silent> F :set iminsert=0<CR>F
" }}}

"-- 
" Change Directoryに関する設定 {{{
command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>') 
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif
    if a:bang == ''
        pwd
    endif
endfunction
" カレントディレクトリをファイルと同じディレクトリに移動する
AlterCommand cd CD

" }}}

"-- 
" バイナリの編集に関する設定 {{{
augroup BinaryXXD
    autocmd!
    autocmd BufReadPre  *.bin let &binary =1
    autocmd BufReadPost * if &binary | silent %!xxd -g 1
    autocmd BufReadPost * set ft=xxd | endif
    autocmd BufWritePre * if &binary | %!xxd -r | endif
    autocmd BufWritePost * if &binary | silent %!xxd -g 1
    autocmd BufWritePost * set nomod | endif
augroup END
" }}}

"-- 
" 現バッファの差分表示 {{{
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
" ファイルまたはバッファ番号を指定して差分表示し、#なら裏バッファと比較
command! -nargs=? -complete=file Diff if '<args>'=='' | browse vertical diffsplit|else| vertical diffsplit <args>|endif
" }}}

"-- 
" Sticky Shiftを実現する {{{
inoremap <expr> ;  <SID>sticky_func()
cnoremap <expr> ;  <SID>sticky_func()
snoremap <expr> ;  <SID>sticky_func()

function! s:sticky_func()
    let l:sticky_table = {
        \',' : '<', '.' : '>', '/' : '?', '\' : '_',
        \'1' : '!', '2' : '"', '3' : '#', '4' : '$', '5' : '%',
        \'6' : '&', '7' : "'", '8' : '(', '9' : ')', '0' : '|', '-' : '=', '^' : '~',
        \':' : '*', ';' : '+', '[' : '{', ']' : '}', '@' : '`',
        \}
    let l:special_table = {
        \"\<ESC>" : "\<ESC>", "\<Space>" : ';', "\<CR>" : ";\<CR>"
        \}

    let l:key = getchar()
    if nr2char(l:key) =~ '\l'
        return toupper(nr2char(l:key))
    elseif has_key(l:sticky_table, nr2char(l:key))
        return l:sticky_table[nr2char(l:key)]
    elseif has_key(l:special_table, nr2char(l:key))
        return l:special_table[nr2char(l:key)]
    else
        return ''
    endif
endfunction
" }}}

"-- 
" マップ定義 {{{
" Normalモード {{{
nnoremap M m

" Window関係 {{{
set splitbelow
set splitright
"デフォルトの最小 window 高さを0に
set winminheight=0
" Ctrl-j/k/h/l で上下左右のWindowへ移動
nmap <C-j> <C-W>j<C-W>_
nmap <C-k> <C-W>k<C-W>_
nmap <C-h> <C-W>h<C-W>_
nmap <C-l> <C-W>l<C-W>_

" 画面分割用のキーマップ
nmap spj <SID>(split-to-j)
nmap spk <SID>(split-to-k)
nmap sph <SID>(split-to-h)
nmap spl <SID>(split-to-l)

nnoremap <SID>(split-to-j) :<C-u>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<CR><C-w>_
nnoremap <SID>(split-to-k) :<C-u>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'split'<CR><C-w>_
nnoremap <SID>(split-to-h) :<C-u>execute 'topleft'    (v:count == 0 ? '' : v:count) 'vsplit'<CR>
nnoremap <SID>(split-to-l) :<C-u>execute 'botright'   (v:count == 0 ? '' : v:count) 'vsplit'<CR>
" }}}

" Move window position {{{
nmap <Space><C-n> <SID>swap_window_next
nmap <Space><C-p> <SID>swap_window_prev
nmap <Space><C-j> <SID>swap_window_j
nmap <Space><C-k> <SID>swap_window_k
nmap <Space><C-h> <SID>swap_window_h
nmap <Space><C-l> <SID>swap_window_l

nnoremap <silent> <SID>swap_window_next :<C-u>call <SID>swap_window_count(v:count1)<CR>
nnoremap <silent> <SID>swap_window_prev :<C-u>call <SID>swap_window_count(-v:count1)<CR>
nnoremap <silent> <SID>swap_window_j :<C-u>call <SID>swap_window_dir(v:count1, 'j')<CR>
nnoremap <silent> <SID>swap_window_k :<C-u>call <SID>swap_window_dir(v:count1, 'k')<CR>
nnoremap <silent> <SID>swap_window_h :<C-u>call <SID>swap_window_dir(v:count1, 'h')<CR>
nnoremap <silent> <SID>swap_window_l :<C-u>call <SID>swap_window_dir(v:count1, 'l')<CR>
nnoremap <silent> <SID>swap_window_t :<C-u>call <SID>swap_window_dir(v:count1, 't')<CR>
nnoremap <silent> <SID>swap_window_b :<C-u>call <SID>swap_window_dir(v:count1, 'b')<CR>
" }}}

" function {{{
function! s:modulo(n, m)
  let d = a:n * a:m < 0 ? 1 : 0
  return a:n + (-(a:n + (0 < a:m ? d : -d)) / a:m + d) * a:m
endfunction

function! s:swap_window_count(n)
  let curwin = winnr()
  let target = s:modulo(curwin + a:n - 1, winnr('$')) + 1
  call s:swap_window(curwin, target)
endfunction

function! s:swap_window_dir(n, dir)
  let curwin = winnr()
  execute a:n 'wincmd' a:dir
  let targetwin = winnr()
  wincmd p
  call s:swap_window(curwin, targetwin)
endfunction

function! s:swap_window(curwin, targetwin)
  let curbuf = winbufnr(a:curwin)
  let targetbuf = winbufnr(a:targetwin)

  if curbuf == targetbuf
  else
    execute 'hide' targetbuf . 'buffer'
    execute a:targetwin 'wincmd w'
    execute curbuf 'buffer'
  endif
endfunction
" }}}

" Buffer関係 {{{
" Hで前のバッファを表示
nnoremap H :<C-u>bp<CR>
" Lで次のバッファを表示
nnoremap L :<C-u>bn<CR>

nnoremap [Buffer]   <Nop>
nmap    <C-s>  [Buffer]

nnoremap <silent> [Buffer]s  :<C-u>buffers<CR>
nnoremap <silent> [Buffer]n  :<C-u>bnext<CR>
nnoremap <silent> [Buffer]p  :<C-u>bprevious<CR>
nnoremap <silent> [Buffer]k  :<C-u>bdelete<CR>
nnoremap <silent> [Buffer]g  :<C-u>buffer<Space>
nmap [Buffer]<C-s>  [Buffer]s
nmap [Buffer]<C-n>  [Buffer]n
nmap [Buffer]<C-p>  [Buffer]p
nmap [Buffer]<C-d>  [Buffer]k
nmap [Buffer]<C-g>  [Buffer]g

" 編集中バッファを別の単独タブに切り出す {{{
function! s:move_window_into_tab_page(target_tabpagenr)
    " Move the current window into a:target_tabpagenr.
    " If a:target_tabpagenr is 0, move into new tab page.
    if a:target_tabpagenr < 0  " ignore invalid number.
        return
    endif
    let original_tabnr = tabpagenr()
    let target_bufnr = bufnr('')
    let window_view = winsaveview()

    if a:target_tabpagenr == 0
        tabnew
        tabmove  " Move new tabpage at the last.
        execute target_bufnr 'buffer'
        let target_tabpagenr = tabpagenr()
    else
        execute a:target_tabpagenr 'tabnext'
        let target_tabpagenr = a:target_tabpagenr
        topleft new
        execute target_bufnr 'buffer'
    endif
    call winrestview(window_view)

    execute original_tabnr 'tabnext'
    if 1 < winnr('$')
        close
    else
        enew
    endif

    execute target_tabpagenr 'tabnext'
endfunction
" <space>ao move current buffer into a new tab
nnoremap <silent> [Buffer]c :<C-u>call <SID>move_window_into_tab_page(0)<CR>
" }}}
" }}}

" Tab関係 {{{
nnoremap [Tabbed]   <Nop>
nmap    <C-t>  [Tabbed]

nnoremap <silent> [Tabbed]s  :<C-u>tabs<CR>
nnoremap <silent> [Tabbed]n  :<C-u>tabnext<CR>
nnoremap <silent> [Tabbed]p  :<C-u>tabprevious<CR>
nnoremap <silent> [Tabbed]c  :<C-u>tabnew<CR>
nnoremap <silent> [Tabbed]k  :<C-u>tabclose<CR>
nnoremap <silent> [Tabbed]o  :<C-u>tabonly<CR>
nnoremap <silent> [Tabbed]r :<C-u>TabRecent<Space>
nmap [Tabbed]<C-s>  [Tabbed]s
nmap [Tabbed]<C-n>  [Tabbed]n
nmap [Tabbed]<C-p>  [Tabbed]p
nmap [Tabbed]<C-c>  [Tabbed]c
nmap [Tabbed]<C-o>  [Tabbed]o
nmap [Tabbed]<C-i>  [Tabbed]i
nnoremap <silent> [Tabbed]l :<C-u>execute 'tabmove' min([tabpagenr() + v:count1 - 1, tabpagenr('$')])<CR>
nnoremap <silent> [Tabbed]h :<C-u>execute 'tabmove' max([tabpagenr() - v:count1 - 1, 0])<CR>
nnoremap <C-n> :<C-u>tabnext<CR>
nnoremap <C-p> :<C-u>tabprevious<CR>
" GNU screen風にタブを移動
for i in range(10)
  execute 'nnoremap <silent>' ('[Tabbed]'.(i))  ((i+1).'gt')
endfor
unlet i
" }}}

" Debug関係 {{{
nnoremap [Argument]   <Nop>
nmap    <C-g>  [Argument]

nnoremap [Argument]<Space>  :<C-u>args<Space>
nnoremap <silent> [Argument]s  :<C-u>args<CR>
nnoremap <silent> [Argument]n  :<C-u>next<CR>
nnoremap <silent> [Argument]p  :<C-u>previous<CR>
nnoremap <silent> [Argument]P  :<C-u>first<CR>
nnoremap <silent> [Argument]N  :<C-u>last<CR>
nnoremap <silent> [Argument]wp :<C-u>wnext<CR>
nnoremap <silent> [Argument]wn :<C-u>wprevious<CR>
" }}}

" Smart <C-f>, <C-b>.
nnoremap <silent> <C-f> z<CR><C-f>z.
nnoremap <silent> <C-b> z-<C-b>z.

" help関係
" Execute help by cursor keyword.
nnoremap <silent> g<C-h>  :<C-u>help<Space><C-r><C-w><CR>
" Grep in help.
nnoremap grh  :<C-u>Hg<Space>
" }}}

" Visualモード {{{
" <CR>をchangeにする
xnoremap <CR> c
" <Tab>をindentにする
xnoremap <Tab> >
" <S-Tab>をunindentにする
xnoremap <S-Tab> <
" Visualモードの*で選択範囲を検索する
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>
" }}}

" Insertモード {{{
" <C-t>をTabにする
inoremap <C-t> <C-v><Tab>
" <C-d>をDelにする
inoremap <C-d> <Del>
" <C-a>で先頭に移動する
inoremap <silent><C-a> <C-o>^
" <C-e>で最後に移動する
inoremap <silent><C-e> <C-o>$
" <C-f>, <C-b>でページを移動する
inoremap <expr><C-f>  pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b>  pumvisible() ? "\<PageUp>"   : "\<Left>"
" <A-h>で前に移動する
inoremap <A-h>  <Left>
" <A-l>で次に移動する
inoremap <A-l>  <Right>
" <A-k>で前行に移動する
inoremap <A-k>  <Up>
" <A-j>で次行に移動する
inoremap <A-j>  <Down>
" <C-u>でundoする
inoremap <C-u>  <C-g>u<C-u>
" <C-h>, <BS>, <Space>でポップアップも消す
inoremap <expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
inoremap <expr><BS> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() . ' ' : ' '
" 括弧を入力した時にカーソルを真ん中へ
inoremap () ()<LEFT>
inoremap [] []<LEFT>
inoremap {} {}<LEFT>
inoremap <> <><LEFT>
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>
" }}}

" Command-lineモード {{{
" <C-d>をDelにする
cnoremap <C-d>          <Del>
" <C-a>で先頭に移動する
cnoremap <C-a>          <Home>
" <C-e>で最後に移動する
cnoremap <C-e>          <End>
" <C-n>, <C-p>でコマンド履歴
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
" <C-s>でコマンド履歴を表示する
cnoremap <C-s> <C-f>
" <C-l>で補完履歴をリスト
cnoremap <C-l> <C-d>
" <A-h>で前の言葉に移動する
cnoremap <A-h>  <S-Left>
" <A-l>で次の言葉に移動する
cnoremap <A-l>  <S-Right>
" }}}

" レジスタ用キーマップ {{{
" <Leader>mでマーク内容を確認
nnoremap <Leader>m  :<C-u>marks<CR>
" <Leader>qでレジスタ内容を確認
nnoremap <Leader>q  :<C-u>registers<CR>
" }}}

" ヘルプコマンド用キーマップ {{{
nnoremap t <Nop>
" tjでジャンプ
nnoremap tj <C-]>
" tlで進む
nnoremap tl :<C-u>tag<CR>
" thで戻る
nnoremap th :<C-u>pop<CR>
" tlで履歴一覧
nnoremap tl :<C-u>tags<CR>
" }}}

" 文字コードを指定して開き直す {{{
" Open in UTF-8 again.
command! -bang -bar -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
AlterCommand utf8 Utf8
" Open in iso-2022-jp again.
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
AlterCommand jis Iso2022jp
" Open in Shift_JIS again.
command! -bang -bar -complete=file -nargs=? Cp932 edit<bang> ++enc=cp932 <args>
AlterCommand sjis Cp932
" Open in EUC-jp again.
command! -bang -bar -complete=file -nargs=? Euc edit<bang> ++enc=euc-jp <args>
AlterCommand euc Euc
" Open in UTF-16 again.
command! -bang -bar -complete=file -nargs=? Utf16 edit<bang> ++enc=ucs-2le <args>
AlterCommand unicode Utf16
" Open in UTF-16BE again.
command! -bang -bar -complete=file -nargs=? Utf16be edit<bang> ++enc=ucs-2 <args>
AlterCommand utf16be Utf16be
" }}}

" ファイルタイプを変更 {{{
nmap <Leader>ew :<C-u>set fileformat=dos<CR>
nmap <Leader>ea :<C-u>set fileformat=mac<CR>
nmap <Leader>eu :<C-u>set fileformat=unix<CR>
" }}}
" }}}

"-- 
" Plug-in用設定 {{{
" Plug-inフォルダを汚したくないが、使ってみたい場合の設定 {{{
function! s:load_optional_rtp(loc)
  let loc = expand(a:loc)
  exe "set rtp+=".loc
  let files = split(globpath(loc, '**/*.vim'), "\n")
  for i in reverse(filter(files, 'filereadable(v:val)'))
    if i !~ '/tests\?/'
      source `=i`
    endif
  endfor
endfunction

" call s:load_optional_rtp("~/dev/eskk.vim")
" }}}

" netrw用設定 {{{
" <C-h>で上のディレクトリに移動
augroup NetrwCommand
    autocmd!
    autocmd FileType netrw nmap <buffer> <C-h> -
augroup END
" }}}

" quickrun.vim用設定 {{{
AlterCommand qr QuickRun
" }}}

" operator-replace用設定 {{{
map R <Plug>(operator-replace)
" }}}

" neocomplcache.vim用設定 {{{
let g:neocomplcache_enable_at_startup = 1
let g:NeoComplCache_SmartCase = 1
let g:NeoComplCache_EnableCamelCaseCompletion = 1
let g:NeoComplCache_EnableUnderbarCompletion = 1
let g:neocomplcache_disable_auto_complete = 1
let g:neocomplcache_manual_completion_start_length = 0
let g:NeoComplCache_MinSyntaxLength = 3
let g:neocomplcache_enable_quick_match = 1
let g:neocomplcache_temporary_dir = $HOME.'/vimfiles/tmp/.neocon'
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*' 
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string() 
" }}}

" skk.vim用設定 {{{
let g:skk_jisyo = $HOME.'/vimfiles/dict/_skk-jisyo'
let g:skk_large_jisyo = $HOME.'/vimfiles/dict/SKK-JISYO.L'
let g:skk_select_cand_keys = "ASDFGHJKL"
let g:skk_egg_like_newline = 1
let g:skk_marker_white = "'"
let g:skk_marker_black = "\""
let g:skk_use_color_cursor = 1
let g:skk_cursor_hira_color = "purple"
let g:skk_cursor_kata_color = "purple"
let g:skk_cursor_zenei_color = "purple"
let g:skk_cursor_ascii_color = "purple"
let g:skk_sticky_key = ';'
let g:skk_auto_save_jisyo = 1
" }}}

" vimshell.vim用設定 {{{
AlterCommand vsh VimShell
AlterCommand vshp VimShellPop
let g:vimshell_temporary_directory = $HOME."/vimfiles"
let g:vimshell_prompt = $USERNAME.">"
let g:vimshell_user_prompt = 'getcwd()'
let g:vimshell_max_list = 15
let g:vimshell_smart_case = 1
let g:vimshell_execute_file_list = {}
call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
let g:vimshell_execute_file_list['pl'] = 'perl'
call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
" }}}
" }}}


set secure

let g:loaded_vimrc = 1
