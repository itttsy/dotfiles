" vim:set ts=4 sts=4 sw=4 tw=0: (この行に関しては:help modelineを参照)

" 初期処理
if v:version < 702
  echoerr 'Error: vimrc: Require the Vim 7.2 or later.'
  finish
endif
for feat in ['multi_byte', 'iconv', 'syntax', 'autocmd']
  if !has(feat)
    echoerr 'Error: vimrc: Require the feature "' . feat . '"'
    finish
  endif
endfor
unlet feat

if !exists('g:loaded_vimrc')
    let g:loaded_vimrc = 0
endif
if g:loaded_vimrc == 0
    mapclear
    mapclear!
endif

"----------
" 初期設定
" <Leader>に'\'の代わりに'<Space>'を使えるようにする
let mapleader = ' '
let g:mapleader = ' '
" <Leader>.で即座にvimrcを開けるようにする
nnoremap <Leader>. :<C-u>edit $MYVIMRC<CR>
" :ReloadVimrcコマンドの追加
" command! ReloadVimrc source $MYVIMRC

set all&
" Vi互換ではなくする
set nocompatible
" ファイルタイプの検出、ファイルタイププラグインを使う、インデントファイルを使う
filetype plugin indent on
" ファイル名の展開にスラッシュを使う
" if has('win32') || has('win64')
"    set shellslash
" endif
" 各種プラグインのロード
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
call altercmd#load()

"----------
" 日本語用エンコード設定
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
" vimをutf-8対応にする場合は以下をコメントイン
" set encoding=utf-8
" source $VIMRUNTIME/delmenu.vim
" set langmenu=menu_ja_jp.utf-8.vim
" source $VIMRUNTIME/menu.vim
" set fileformat=unix
" scriptencoding utf-8

" modeline内にfencを指定されている場合の対応
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

" 文字コードを指定して開き直す
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

"----------
" プラットフォーム依存の問題の為の設定
" Windows/Linuxにおいて、.vimと$VIM/vimfilesの違いを吸収する
if has('win32') || has('win64')
    let $DOTVIM = $HOME . '/vimfiles'
else
    let $DOTVIM = $HOME . '/.vim'
endif

" ファイル名に大文字小文字の区別がないシステム用の設定
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
    set tags=./tags,tags
endif

" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
    set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
    let $PATH = $VIM . ';' . $PATH
endif

" Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
if has('mac')
    set iskeyword=@,48-57,_,128-167,224-235
endif

" helptagsの生成
helptags $DOTVIM/doc

"----------
" IME切り替えの為の設定
if has('multi_byte_ime')
    highlight CursorIM guibg=Purple guifg=NONE
    set iminsert=0 imsearch=0
    inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

"----------
" GUI固有ではない画面表示の設定
if !has('gui_running')
    colorscheme less
endif
" 画面表示に関する設定
set guioptions=aegip
" 構文強調表示を有効にする
if &t_Co > 2 || has("gui_running")
    syntax enable
    set hlsearch
endif
" 長い行について折り返す
set wrap
" 現在のモードを表示する
set showmode
" 行番号を表示する
set number
" カーソルが何行目何列目にあるか表示しない
set noruler

" title
" ウィンドウのタイトルを表示する
set title
set statusline=
    \%<%{expand('%:p')}\ %m%r%h%w
    \%=%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}[%{tabpagenr()}/%{tabpagenr('$')}]\ %P

" statusline
" タブページのラベルを表示しない
set showtabline=0
" ステータス行を常に表示
set laststatus=2
" コマンドラインに使われる画面上の行数
set cmdheight=1
" コマンドを画面最下行に表示する
set showcmd

" gui
" ビープ音にビジュアルベルを使用する
set visualbell
" Vimを終了したときにコンソール画面を復元しない
set norestorescreen
set t_ti=
set t_te=

" cursor
" Insertモードでautoindent、改行を超えてバックスペースを働かせる
set backspace=2

" listchars
" タブ文字や行末を表示する
set list
" タブ文字や行末に表示する文字を指定する
set listchars=tab:>_,extends:>,precedes:<,eol:_,trail:~

" fillchars
" ステータス行と垂直分割の区切りを埋める文字を指定する
set fillchars=stl:\ ,stlnc::,vert:\ ,fold:-,diff:-

" scroll
" CTRL-UやCTRL-Dでスクロールする行数
set scroll=5
" カーソルの上または下に表示する行数
" set scrolloff=9999

" case arc
" 対応する括弧にジャンプする
set showmatch
" 対応する括弧にジャンプしている時間
set matchtime=3
" ジャンプ中に文字を入力するとカーソルがすぐに元の場所に戻る
set cpoptions& cpoptions-=m
" 対応する括弧のペアの追加
set matchpairs& matchpairs+=<:>

" fold
" 折り畳みを使用する
set foldenable
" マーカーで折り畳みを指定する
set foldmethod=marker
" 折り畳みを表示する
set foldcolumn=2
" 行頭で h を押すと選択範囲に含まれるfoldを閉じる
vnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
" 折畳上で l を押すと選択範囲に含まれるfoldを開く
vnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'

" 現在のfoldのみ開いた状態にする
function! s:fold_current_expand()
    silent! %foldclose!
    normal! zvzz
endfunc
nnoremap z<Space> :<C-u>call <SID>fold_current_expand()<CR>

" カレントウィンドウにのみ罫線を引く
augroup cch
    autocmd!
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END

" misc
" ファイルフォーマットの設定
set fileformats=unix,dos,mac
" マルチバイト文字の幅の扱いを指定する
set ambiwidth=double
" Diffモード用の設定
set diffopt=filler,vertical
" ヘルプ用言語設定
set helplang=ja,en
" 行連結コマンドにおいて空白を挿入しない
set nojoinspaces
" 全角スペースを表示する
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=green
  silent! match ZenkakuSpace /　/
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd VimEnter,BufEnter * call ZenkakuSpace()
  augroup END
endif

"----------
" マウスに関する設定
if has('mouse')
    set mouse=a
endif

"----------
" 編集に関する設定
" indent
" 新しい行を開始したときに新しい行のインデントを適切に設定する
set autoindent
set smartindent
" Insertモードでタブ文字を挿入するときに代わりに適切な数の空白を使う
set expandtab
set smarttab
set tabstop=8
set softtabstop=4
set shiftwidth=4
" インデントをshiftwidthの値の整数倍にまとめる
set shiftround

" completion
" キーワード補完にディクショナリーファイルを追加
set complete& complete+=k
augroup DictFile
    autocmd!
    autocmd FileType * execute printf("setlocal dict=$DOTVIM/dict/%s.dict", &filetype)
    autocmd FileType pl :<C-u>set dictionary& dictionary+=$DOTVIM'/dict/perl.dict'
augroup END
" コマンドライン補完を拡張モードで行う
set wildmenu
set wildchar=<Tab>
" Insertモード補完のポップアップに表示される項目数の最大値
set pumheight=20

" swap
" スワップファイルを使用しない
set noswapfile
set updatecount=0
if has('unix')
    set nofsync
    set swapsync=
endif

" backup
" バックアップファイルを使用する
set backup
set backupdir=$DOTVIM/backup

" persistent undo
" 無限Undoを使用する
set undofile
set undodir=$DOTVIM/tmp/undo

" misc
" バッファを放棄したときに開放しない
set hidden
" フォーマットオプションを指定する
set formatoptions& formatoptions+=mM
" 数の増減に関する設定
set nrformats& nrformats-=octal
" grepで利用するプログラム
set grepprg=internal
" クリップボードに利用するレジスタの設定
set clipboard& clipboard+=unnamed,autoselect
" YをDやPに合わせる
nnoremap Y y$

" 文字のない場所にもカーソルを持っていけるようにする
set virtualedit& virtualedit+=all
if has('virtualedit') && &virtualedit =~# '\<all\>'
    nnoremap <expr> p (col('.') >= col('$') ? '$' : '') . 'p'
endif

" カレントディレクトリをファイルと同じディレクトリに移動する
" set autochdir
au BufEnter * execute ":silent! lcd " . escape(expand("%:p:h"), ' ')

" 現在編集中のバッファのファイル名を変更する
command! -nargs=+ -bang -complete=file Rename let pbnr=fnamemodify(bufname('%'), ':p')|exec 'f '.escape(<q-args>, ' ')|w<bang>|call delete(pbnr)

" 縦に連番を入力する
nnoremap <silent> co :<C-u>ContinuousNumber <C-a><CR>
vnoremap <silent> co :<C-u>ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor

" 内容が空の.txtファイルを保存したら自動で削除する
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

" 使い捨て用のファイルを生成する
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
    let l:junk_dir = $DOTVIM . '/vim_junk' . strftime('/%Y/%m')
    if !isdirectory(l:junk_dir)
        call mkdir(l:junk_dir, 'p')
    endif
    let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
    if l:filename != ''
        execute 'edit ' . l:filename
    endif
endfunction

" タブページ毎にカレントディレクトリを設定する
AlterCommand cd TabpageCD
nnoremap tcd :<C-u>TabpageCD %:p:h<CR>

command!
\ -bar -complete=dir -nargs=?
\ CD
\ TabpageCD <args>
command!
\ -bar -complete=dir -nargs=?
\ TabpageCD
\ execute 'cd' fnameescape(expand(<q-args>))
\ | let t:cwd = getcwd()
augroup TabpageCD
    autocmd!
    autocmd TabEnter *
    \ if exists('t:cwd') && !isdirectory(t:cwd)
    \ | unlet t:cwd
    \ | endif
    \ | if !exists('t:cwd')
    \ | let t:cwd = getcwd()
    \ | endif
    \ | execute 'cd' fnameescape(expand(t:cwd))
augroup END

"----------
" 検索に関する設定
" 検索コマンドを打ち込んでいる間に、打ち込んでいるところまでのパターンマッチを行なう
set incsearch
" 検索において大文字と小文字を区別しない
set ignorecase
" 検索において大文字を含んでいたらignorecaseを上書きする
set smartcase
" 検索がファイル末尾まで進んだらファイル先頭から再び検索する
set wrapscan
" 検索パターン入力中は/で\/を入力する
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
" 検索パターン入力中は?で\?を入力する
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
" fを利用するときにIMEをオフにする
nnoremap <silent> f :<C-u>set iminsert=0<CR>f
nnoremap <silent> F :<C-u>set iminsert=0<CR>F

"----------
" バイナリの編集に関する設定
augroup BinaryXXD
    autocmd!
    autocmd BufReadPre   *.bin let &binary =1
    autocmd BufReadPost  * if &binary | silent %!xxd -g 1
    autocmd BufReadPost  * set ft=xxd | endif
    autocmd BufWritePre  * if &binary | %!xxd -r | endif
    autocmd BufWritePost * if &binary | silent %!xxd -g 1
    autocmd BufWritePost * set nomod | endif
augroup END

"----------
" 現バッファの差分表示
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
" ファイルまたはバッファ番号を指定して差分表示し、#なら裏バッファと比較
command! -nargs=? -complete=file Diff if '<args>'=='' | browse vertical diffsplit|else| vertical diffsplit <args>|endif

"----------
" Sticky Shiftを実現する
let g:sticky_us_keyboard = 0
inoremap <expr> ; <SID>sticky_func()
cnoremap <expr> ; <SID>sticky_func()
snoremap <expr> ; <SID>sticky_func()

function! s:sticky_func()
    let l:sticky_table = {
        \'0' : {
            \'1' : '!', '2' : '"', '3' : '#', '4' : '$', '5' : '%',
            \'6' : '&', '7' : "'", '8' : '(', '9' : ')', '0' : '|',
            \'-' : '=', '^' : '~',
            \'@' : '`', '[' : '{',
            \';' : '+', ':' : '*', ']' : '}',
            \',' : '<', '.' : '>', '/' : '?', '\' : '_',
        \},
        \'1' : {
            \'1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
            \'6' : '^', '7' : "&", '8' : '*', '9' : '(', '0' : ')',
            \'`' : '~', '-' : '_', '=' : '+',
            \'[' : '{', ']' : '}', '\' : '|',
            \';' : ':', "'" : '"',
            \',' : '<', '.' : '>', '/' : '?',
        \}
    \}
    let l:special_table = {
        \"\<ESC>" : "\<ESC>", "\<Space>" : ';', "\<CR>" : ";\<CR>"
    \}

    let l:key = getchar()
    if nr2char(l:key) =~ '\l'
        return toupper(nr2char(l:key))
    elseif has_key(get(l:sticky_table, g:sticky_us_keyboard), nr2char(l:key))
        return get(l:sticky_table, g:sticky_us_keyboard)[nr2char(l:key)]
    elseif has_key(l:special_table, nr2char(l:key))
        return l:special_table[nr2char(l:key)]
    else
        return ''
    endif
endfunction

"----------
" マップ定義 - 全般
" 'と`を入れ替える
noremap ' `
noremap ` '

"----------
" マップ定義 - Normalモード
" Window関係
set splitbelow
set splitright
"デフォルトの最小 window 高さを0に
set winminheight=0
" 画面を再描画する
nnoremap <C-z> <C-l>
" <C-j>/<C-k/<C-h/<C-l> で上下左右のWindowへ移動
nnoremap <C-j> <C-W>j<C-W>_
nnoremap <C-k> <C-W>k<C-W>_
nnoremap <C-h> <C-W>h<C-W>_
nnoremap <C-l> <C-W>l<C-W>_
nnoremap <C-w><Space> <C-w>w<C-W>_

" 画面分割用のキーマップ
nmap spj <SID>(split-to-j)
nmap spk <SID>(split-to-k)
nmap sph <SID>(split-to-h)
nmap spl <SID>(split-to-l)

nnoremap <SID>(split-to-j) :<C-u>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<CR><C-w>_
nnoremap <SID>(split-to-k) :<C-u>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'split'<CR><C-w>_
nnoremap <SID>(split-to-h) :<C-u>execute 'topleft'    (v:count == 0 ? '' : v:count) 'vsplit'<CR>
nnoremap <SID>(split-to-l) :<C-u>execute 'botright'   (v:count == 0 ? '' : v:count) 'vsplit'<CR>

" ウィンドウを入れ替える
nnoremap [Swap] <Nop>
nmap <C-s> [Swap]

nmap [Swap]<C-n> <SID>swap_window_next
nmap [Swap]<C-p> <SID>swap_window_prev
nmap [Swap]<C-j> <SID>swap_window_j
nmap [Swap]<C-k> <SID>swap_window_k
nmap [Swap]<C-h> <SID>swap_window_h
nmap [Swap]<C-l> <SID>swap_window_l

nnoremap <silent> <SID>swap_window_next :<C-u>call <SID>swap_window_count(v:count1)<CR>
nnoremap <silent> <SID>swap_window_prev :<C-u>call <SID>swap_window_count(-v:count1)<CR>
nnoremap <silent> <SID>swap_window_j :<C-u>call <SID>swap_window_dir(v:count1, 'j')<CR>
nnoremap <silent> <SID>swap_window_k :<C-u>call <SID>swap_window_dir(v:count1, 'k')<CR>
nnoremap <silent> <SID>swap_window_h :<C-u>call <SID>swap_window_dir(v:count1, 'h')<CR>
nnoremap <silent> <SID>swap_window_l :<C-u>call <SID>swap_window_dir(v:count1, 'l')<CR>
nnoremap <silent> <SID>swap_window_t :<C-u>call <SID>swap_window_dir(v:count1, 't')<CR>
nnoremap <silent> <SID>swap_window_b :<C-u>call <SID>swap_window_dir(v:count1, 'b')<CR>

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

" Buffer関係
" Hで前のバッファを表示
nnoremap H :<C-u>bp<CR>
" Lで次のバッファを表示
nnoremap L :<C-u>bn<CR>
" <Leader>bで現在のバッファを表示
nnoremap <Leader>b :<C-u>buffers<CR>
" 最後の2 digitで移動する
command! -count=1 -nargs=0 LastTwoDigitMove call LastTwoDigitMove(<count>)
function! LastTwoDigitMove(bound)
    " for example when you are at line num 123 and typed 3gl
    " getpos('.')[1] is 123
    " a:bound is 125
    " the goal is 103
    let current = getpos('.')[1]
    let to = current / 100 * 100 + a:bound - current + 1
    execute to
endfunction
nnoremap <silent> gl :LastTwoDigitMove<Cr>

" Tab関係
nnoremap [Tabbed] <Nop>
nnoremap <C-t> <Nop>
nmap <C-t> [Tabbed]

nnoremap <silent> [Tabbed]s :<C-u>tabs<CR>
nnoremap <silent> [Tabbed]n :<C-u>tabnext<CR>
nnoremap <silent> [Tabbed]<Space> :<C-u>tabnext<CR>
nnoremap <silent> [Tabbed]p :<C-u>tabprevious<CR>
nnoremap <silent> [Tabbed]c :<C-u>tabnew<CR>
nnoremap <silent> [Tabbed]k :<C-u>tabclose<CR>
nnoremap <silent> [Tabbed]o :<C-u>tabonly<CR>
nnoremap <silent> [Tabbed]r :<C-u>TabRecent<Space>
nnoremap <silent> [Tabbed]l :<C-u>execute 'tabmove' min([tabpagenr() + v:count1 - 1, tabpagenr('$')])<CR>
nnoremap <silent> [Tabbed]h :<C-u>execute 'tabmove' max([tabpagenr() - v:count1 - 1, 0])<CR>
" GNU screen風にタブを移動
for i in range(10)
    execute 'nnoremap <silent>' ('[Tabbed]'.(i))  ((i).'gt')
endfor
unlet i
" 現在編集中のバッファをタブに切り出す
function! s:move_window_into_tab_page(target_tabpagenr)
    if a:target_tabpagenr < 0
        return
    endif
    let original_tabnr = tabpagenr()
    let target_bufnr = bufnr('')
    let window_view = winsaveview()
    if a:target_tabpagenr == 0
        tabnew
        tabmove
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
nnoremap <silent> [Tabbed]l :<C-u>call <SID>move_window_into_tab_page(0)<Cr>

" Smart <C-f>, <C-b>
nnoremap <silent> <C-f> z<CR><C-f>z.
nnoremap <silent> <C-b> z-<C-b>z.

" help関係
" カーソル下のキーワードでヘルプを実行する
nnoremap <silent> g<C-h> :<C-u>help<Space><C-r><C-w><CR>
" ヘルプをgrepする
nnoremap grh :<C-u>Hg<Space>

" misc
" ファイルタイプを変更
nmap <Leader>ew :<C-u>set fileformat=dos<CR>
nmap <Leader>ea :<C-u>set fileformat=mac<CR>
nmap <Leader>eu :<C-u>set fileformat=unix<CR>

"----------
" マップ定義 - Visualモード
" <CR>をchangeにする
xnoremap <CR> c
" <Tab>をindentにする
xnoremap <Tab> >
" <S-Tab>をunindentにする
xnoremap <S-Tab> <
" Visualモードの*で選択範囲を検索する
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>

"----------
" マップ定義 - Insertモード
" <C-t>をTabにする
inoremap <C-t> <C-v><Tab>
" <C-d>をDelにする
inoremap <C-d> <Del>
" <C-a>で先頭に移動する
inoremap <silent><C-a> <C-o>^
" <C-e>で最後に移動する
inoremap <silent><C-e> <C-o>$
" <A-h>で前文字に移動する
inoremap <A-h> <Left>
" <A-l>で次文字に移動する
inoremap <A-l> <Right>
" <A-k>で前行に移動する
inoremap <A-k> <Up>
" <A-j>で次行に移動する
inoremap <A-j> <Down>
" <C-u>でundoする
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
" <C-g><C-u>で直下の単語を大文字に変換する
inoremap <C-g><C-u> <ESC>gUiw`]a
" 括弧を入力したときにカーソルを真ん中へ
inoremap () ()<LEFT>
inoremap [] []<LEFT>
inoremap {} {}<LEFT>
inoremap <> <><LEFT>
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>

"----------
" マップ定義 - Command-lineモード
" <C-d>をDelにする
cnoremap <C-d> <Del>
" <C-a>で先頭に移動する
cnoremap <C-a> <Home>
" <C-e>で最後に移動する
cnoremap <C-e> <End>
" <C-n>, <C-p>でコマンド履歴
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
" <C-s>でコマンド履歴を表示する
cnoremap <C-s> <C-f>
" <C-l>で補完履歴をリスト
cnoremap <C-l> <C-d>
" <A-h>で前の言葉に移動する
cnoremap <A-h> <S-Left>
" <A-l>で次の言葉に移動する
cnoremap <A-l> <S-Right>

"----------
" マップ定義 - テキストオブジェクト用キーマップ
onoremap aa a>
vnoremap aa a>
onoremap ia i>
vnoremap ia i>

onoremap ar a]
vnoremap ar a]
onoremap ir i]
vnoremap ir i]

"----------
" マップ定義 - レジスタ用キーマップ
" <Leader>mでマーク内容を確認
nnoremap <Leader>m :<C-u>marks<CR>
" <Leader>qでレジスタ内容を確認
nnoremap <Leader>q :<C-u>registers<CR>

"----------
" マップ定義 - ヘルプコマンド用キーマップ
nnoremap t <Nop>
" tjでジャンプ
nnoremap tj <C-]>
" tlで進む
nnoremap tl :<C-u>tag<CR>
" thで戻る
nnoremap th :<C-u>pop<CR>
" tlで履歴一覧
nnoremap tl :<C-u>tags<CR>

"----------
" Plug-in用設定
" Kaoriya版でのプラグイン
if has('Kaoriya')
    let plugin_autodate_disable  = 1
    let plugin_cmdex_disable     = 0
    let plugin_dicwin_disable    = 1
    let plugin_format_disable    = 1
    let plugin_hz_ja_disable     = 1
    let plugin_scrnmode_disable  = 1
    let plugin_verifyenc_disable = 1
endif

" netrw用設定
" hで上のディレクトリに移動、lでディレクトリを展開もしくはファイルを開く
augroup NetrwCommand
    autocmd!
    autocmd FileType netrw nmap <buffer> h -
    autocmd FileType netrw nmap <buffer> l <CR>
augroup END

" vimfiler用設定
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_trashbox_directory = $DOTVIM . '/tmp/vimfiler_trashbox'
let g:vimfiler_external_copy_directory_command = 'cp -r $src $dest'
let g:vimfiler_external_copy_file_command = 'cp $src $dest'
let g:vimfiler_external_delete_command = 'rm -r $srcs'
let g:vimfiler_external_move_command = 'mv $srcs $dest'
" Enable file operation commands.
"let g:vimfiler_safe_mode_by_default = 0

" vimshell用設定
AlterCommand vsh VimShell
AlterCommand vshp VimShellPop
AlterCommand vshe VimShellExecute
let g:vimshell_temporary_directory = $DOTVIM . '/tmp/vimshell'
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_enable_smart_case = 1
let g:vimshell_split_height = 50

if has('win32') || has('win64')
    let g:vimshell_prompt = $USERNAME."% "
else
    let g:vimshell_prompt = $USER."% "
endif

augroup VimShell
    autocmd!
    autocmd FileType vimshell
        \ call vimshell#altercmd#define('g', 'git')
        \| call vimshell#altercmd#define('i', 'iexe')
        \| call vimshell#altercmd#define('ll', 'ls -l')
augroup END

" skk.vim用設定
let g:skk_jisyo = $DOTVIM . '/dict/_skk-jisyo'
let g:skk_large_jisyo = $DOTVIM . '/dict/SKK-JISYO.L'
let g:skk_select_cand_keys = "ASDFGHJKL"
let g:skk_egg_like_newline = 1
let g:skk_marker_white = "'"
let g:skk_marker_black = "\""
let g:skk_use_color_cursor = 1
let g:skk_cursor_hira_color = "Purple"
let g:skk_cursor_kata_color = "Purple"
let g:skk_cursor_zenei_color = "Purple"
let g:skk_cursor_ascii_color = "Purple"
let g:skk_sticky_key = ';'
let g:skk_auto_save_jisyo = 1

" neocomplcache.vim用設定
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_disable_auto_complete = 0
let g:neocomplcache_manual_completion_start_length = 0
let g:neocomplcache_enable_auto_delimiter = 1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_max_filename_width = 30
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_quick_match = 1
let g:neocomplcache_quick_match_patterns = { 'default' : '@' }
let g:neocomplcache_enable_auto_select = 0
let g:neocomplcache_temporary_dir = $DOTVIM . '/tmp/neocon'
imap <expr><C-l> <Plug>(neocomplcache_snippets_expand)
smap <expr><C-l> <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-k> neocomplcache#complete_common_string() 
" SuperTab風snippets
imap <expr>] neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\]"
" <CR>, <C-h>, <BS>, <Space>でポップアップも消す
inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
inoremap <expr><C-h> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr><Space> neocomplcache#smart_close_popup() . "\<Space>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-b> neocomplcache#cansel_popup()

" echodoc用設定
let g:echodoc_enable_at_startup = 1

" unite.vim用設定
AlterCommand unite Unite
AlterCommand u Unite
let g:unite_data_directory = $DOTVIM . '/unite'
let g:unite_enable_start_insert = 1
call unite#set_substitute_pattern('files', '\*\*\+', '*', -1)
call unite#set_substitute_pattern('files', '^@', substitute(substitute($DOTVIM . "/vim_junk",  '\\', '/', 'g'), ' ', '\\\\ ', 'g'), -100)
" The prefix key.
nnoremap [unite] <Nop>
nmap <C-u> [unite]

nnoremap [unite]<Space> :<C-u>Unite<Space>
nnoremap <silent> [unite]u :<C-u>UniteWithCurrentDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]<C-u> :<C-u>UniteWithCurrentDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]<C-r> :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]s :<C-u>Unite source<CR>
nnoremap <silent> [unite]<C-s> :<C-u>Unite source<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer_tab<CR>
nnoremap <silent> [unite]<C-b> :<C-u>Unite buffer_tab<CR>
nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files file<CR>
nnoremap <silent> [unite]<C-f> :<C-u>Unite -buffer-name=files file<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]<C-m> :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]h :<C-u>Unite help<CR>
nnoremap <silent> [unite]<C-h> :<C-u>Unite help<CR>
nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
nnoremap <silent> [unite]<C-o> :<C-u>Unite outline<CR>
nnoremap <silent> [unite]g :<C-u>Unite grep<CR>
nnoremap <silent> [unite]<C-g> :<C-u>Unite grep<CR>
augroup UniteSetting
    autocmd!
    autocmd FileType unite call s:unite_my_settings()
augroup END
function! s:unite_my_settings()
    nmap <buffer> <ESC> <Plug>(unite_exit)
    imap <buffer> jj <Plug>(unite_insert_leave)<Plug>(unite_loop_cursor_down)
    imap <buffer> <silent> <C-n> <Plug>(unite_insert_leave)<Plug>(unite_loop_cursor_down)
    nmap <buffer> <silent> <C-n> <Plug>(unite_loop_cursor_down)
    nmap <buffer> <silent> <C-p> <Plug>(unite_loop_cursor_up)
    nmap <buffer> <silent> <C-u> <Plug>(unite_append_end)<Plug>(unite_delete_backward_line)
    imap <buffer> <silent> <C-w> <Plug>(unite_delete_backward_path)
    nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('right')
endfunction

" ref.vim用設定
AlterCommand ref Ref
let g:ref_cache_dir = $DOTVIM . '/tmp/ref'
let g:ref_use_vimproc = 1
let g:ref_alc_encoding = "Shift_JIS"
let g:ref_alc_use_cache = 1
nnoremap <silent> ma :<C-u>call ref#jump('normal', 'alc', {'noenter': 1})<CR>
vnoremap <silent> ma :<C-u>call ref#jump('visual', 'alc', {'noenter': 1})<CR>
nnoremap <silent> mp :<C-u>call ref#jump('normal', 'perldoc', {'noenter': 1})<CR>
vnoremap <silent> mp :<C-u>call ref#jump('visual', 'perldoc', {'noenter': 1})<CR>
AlterCommand ma :<C-u>Ref alc
AlterCommand mp :<C-u>Ref perldoc

" operator-replace用設定
map R <Plug>(operator-replace)

" quickrun.vim用設定
AlterCommand qr QuickRun

" zoom.vim用設定
nnoremap <silent> <C-kPlus> :<C-u>ZoomIn<CR>
nnoremap <silent> <C-kMinus> :<C-u>ZoomOut<CR>
nnoremap <silent> <C-k0> :<C-u>ZoomReset<CR>

set secure

let g:loaded_vimrc = 1
