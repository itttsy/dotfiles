" vim:set ts=4 sts=4 sw=4 tw=0: (この行に関しては:help modelineを参照)
if !exists('g:loaded_vimrc')
    let g:loaded_vimrc = 0
endif

"----------
" 初期設定
" <Leader>に'\'の代わりに'm'を使えるようにする
let mapleader = 'm'
let g:mapleader = 'm'
let g:maplocalleader = ','
nnoremap M m
" <Leader>.で即座にvimrcを開けるようにする
nnoremap <Leader>. :<C-u>edit $MYVIMRC<CR>
" :ReloadVimrcコマンドの追加
command! ReloadVimrc source $MYVIMRC

set iminsert=0
set nocompatible
filetype plugin indent on
if !has('syntax')
    syntax enable
endif
" if has('win32') || has('win64')
"     set shellslash
" endif
call altercmd#load()

"----------
" 日本語用エンコード設定
set encoding=cp932
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
" vimをutf-8対応にする場合は以下をコメントイン
" set encoding=utf-8
" source $VIMRUNTIME/delmenu.vim
" set langmenu=menu_ja_jp.utf-8.vim
" source $VIMRUNTIME/menu.vim

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
    let $DOTVIM = $HOME."/vimfiles"
else
    let $DOTVIM = $HOME."/.vim"
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
if has('mac')
"    helptags ~/.vim/doc
elseif has('win32')
"    helptags ~/vimfiles/doc
endif

"----------
" GUI固有ではない画面表示の設定
colorscheme less
set wrap
set showmode
set showmatch
set number
set noruler

" title
set title
set statusline=
    \%<%{expand('%:p')}\ %m%r%h%w
    \%=%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}[%{tabpagenr()}/%{tabpagenr('$')}]\ %P

" statusline
set showtabline=0
set laststatus=2
set cmdheight=1
set showcmd

" gui
set t_Co=256
set visualbell
set norestorescreen
set t_ti=
set t_te=

" cursor
set cursorline
set backspace=2

" listchars
set list
set listchars=tab:>_,extends:>,precedes:<,eol:_,trail:~

" fillchars
set fillchars=stl:\ ,stlnc::,vert:\ ,fold:-,diff:-

" scroll
set scroll=5
set scrolloff=9999

" case arc
set showmatch
set cpoptions-=m
set matchtime=3
set matchpairs+=<:>

" fold
set foldenable
set foldmethod=marker
set foldcolumn=3
" 行頭で h を押すと選択範囲に含まれる折畳を閉じる
vnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
" 折畳上で l を押すと選択範囲に含まれる折畳を開く
vnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'

" 現在のfoldのみ開いた状態にする
function! s:fold_current_expand()
    silent! %foldclose!
    normal! zvzz
endfunc
nnoremap z<Space> :<C-u>call <SID>fold_current_expand()<CR>

" カレントウィンドウにのみ罫線を引く
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END

highlight CursorLine ctermbg=black guibg=black

" misc
set ambiwidth=double
set diffopt=filler,vertical
set helplang=ja,en
set nojoinspaces

"----------
" マウスに関する設定
if has('mouse')
    set mouse=a
endif

"----------
" 編集に関する設定
" indent
set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=4
set shiftround
set shiftwidth=4

" completion
autocmd FileType pl :<C-u>set dictionary+=$DOTVIM'/dict/perl.dict'
set complete+=k
set wildmenu
set wildchar=<Tab>
set pumheight=20

" swap
set noswapfile
set updatecount=0
if has('unix')
    set nofsync
    set swapsync=
endif

" backup
set backup
set backupdir=$DOTVIM/backup

" persistent undo
set undofile
set undodir=$DOTVIM/tmp/undo

" misc
set hidden
set formatoptions& formatoptions+=mM
set nrformats& nrformats-=octal
set virtualedit+=block
set grepprg=internal
set clipboard& clipboard+=unnamed,autoselect
set autochdir
nnoremap Y y$
augroup DictFile
    autocmd!
    autocmd FileType * execute printf("setlocal dict=$DOTVIM/dict/%s.dict", &filetype)
augroup END
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
    let l:junk_dir = $DOTVIM . '/vim_junk'. strftime('/%Y/%m')
    if !isdirectory(l:junk_dir)
        call mkdir(l:junk_dir, 'p')
    endif
    let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
    if l:filename != ''
        execute 'edit ' . l:filename
    endif
endfunction

"----------
" 検索に関する設定
set nohlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan
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
" <C-j>/<C-k/<C-h/<C-l> で上下左右のWindowへ移動
nnoremap <C-j> <C-W>j<C-W>_
nnoremap <C-k> <C-W>k<C-W>_
nnoremap <C-h> <C-W>h<C-W>_
nnoremap <C-l> <C-W>l<C-W>_

" 画面分割用のキーマップ
nnoremap [Window] <Nop>
nmap <C-s> [Window]

nmap spj <SID>(split-to-j)
nmap spk <SID>(split-to-k)
nmap sph <SID>(split-to-h)
nmap spl <SID>(split-to-l)

nnoremap <SID>(split-to-j) :<C-u>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<CR><C-w>_
nnoremap <SID>(split-to-k) :<C-u>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'split'<CR><C-w>_
nnoremap <SID>(split-to-h) :<C-u>execute 'topleft'    (v:count == 0 ? '' : v:count) 'vsplit'<CR>
nnoremap <SID>(split-to-l) :<C-u>execute 'botright'   (v:count == 0 ? '' : v:count) 'vsplit'<CR>

" Move window position
nmap [Window]<C-n> <SID>swap_window_next
nmap [Window]<C-p> <SID>swap_window_prev
nmap [Window]<C-j> <SID>swap_window_j
nmap [Window]<C-k> <SID>swap_window_k
nmap [Window]<C-h> <SID>swap_window_h
nmap [Window]<C-l> <SID>swap_window_l

nnoremap <silent> <SID>swap_window_next :<C-u>call <SID>swap_window_count(v:count1)<CR>
nnoremap <silent> <SID>swap_window_prev :<C-u>call <SID>swap_window_count(-v:count1)<CR>
nnoremap <silent> <SID>swap_window_j :<C-u>call <SID>swap_window_dir(v:count1, 'j')<CR>
nnoremap <silent> <SID>swap_window_k :<C-u>call <SID>swap_window_dir(v:count1, 'k')<CR>
nnoremap <silent> <SID>swap_window_h :<C-u>call <SID>swap_window_dir(v:count1, 'h')<CR>
nnoremap <silent> <SID>swap_window_l :<C-u>call <SID>swap_window_dir(v:count1, 'l')<CR>
nnoremap <silent> <SID>swap_window_t :<C-u>call <SID>swap_window_dir(v:count1, 't')<CR>
nnoremap <silent> <SID>swap_window_b :<C-u>call <SID>swap_window_dir(v:count1, 'b')<CR>

" function
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
" <Space>llで現在のバッファを表示
nnoremap <Space>ll :<C-u>buffers<CR>

" Tab関係
nnoremap [Tabbed] <Nop>
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
nnoremap <C-n> :<C-u>tabnext<CR>
nnoremap <C-p> :<C-u>tabprevious<CR>
" GNU screen風にタブを移動
for i in range(10)
    execute 'nnoremap <silent>' ('[Tabbed]'.(i))  ((i+1).'gt')
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
" Execute help by cursor keyword.
nnoremap <silent> g<C-h> :<C-u>help<Space><C-r><C-w><CR>
" Grep in help.
nnoremap grh :<C-u>Hg<Space>

" misc
" スペルミスを指摘する
nnoremap <silent> <Space>sp :<C-u>setlocal spell! spelllang=en_us<CR>:setlocal spell?<CR>
" Vimでクリップボードとやりとりをする
nnoremap <C-r><C-u> <C-r><C-o>+
" gZZでVim終了時に画面をクリアしないようにする
nmap <silent> gZZ :set t_te= t_ti= <cr>:quit<cr>:set t_te& t_ti&<cr>
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
" <C-f>, <C-b>でページを移動する
inoremap <expr><C-f> pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b> pumvisible() ? "\<PageUp>"   : "\<Left>"
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
" <C-y>でペースト
inoremap <C-y> <C-r>*
" 括弧を入力した時にカーソルを真ん中へ
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
" Plug-inフォルダを汚したくないが、使ってみたい場合の設定
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

" skk.vim用設定
let g:skk_jisyo = $DOTVIM.'/dict/_skk-jisyo'
let g:skk_large_jisyo = $DOTVIM.'/dict/SKK-JISYO.L'
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
let g:neocomplcache_enable_auto_select = 0
let g:neocomplcache_temporary_dir = $DOTVIM.'/tmp/neocon'
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
inoremap <expr><C-e> neocomplcache#cansel_popup()

" unite.vim用設定
AlterCommand unite Unite
AlterCommand u Unite
let g:unite_data_directory = $DOTVIM.'/unite'
let g:unite_enable_start_insert = 0
" The prefix key.
nnoremap [unite] <Nop>
nmap <C-u> [unite]

nnoremap <silent> [unite]u :<C-u>UniteWithCurrentDir buffer file_mru file<CR>
nnoremap <silent> [unite]h :<C-u>Unite help<CR>
nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
    imap <buffer> jj <Plug>(unite_insert_leave)
    nnoremap <buffer> t G
endfunction

let s:unite_action = {
\   'is_selectable': 1,
\ }

" 選択したファイルをまとめて別タブに縦に分割して開く
function! s:unite_action.func(candidates)
  tabnew `=a:candidates[0].action__path`
  for c in a:candidates[1 :]
    vsplit `=c.action__path`
  endfor
endfunction

call unite#custom_action('openable', 'tabvsplit', s:unite_action)
unlet! s:unite_action

" 置換用設定
call unite#set_substitute_pattern('file', '\$\w\+', '\=eval(submatch(0))', 200)

call unite#set_substitute_pattern('file', '[^~.]\zs/', '*/*', 20)
call unite#set_substitute_pattern('file', '/\ze[^*]', '/*', 10)

call unite#set_substitute_pattern('file', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
call unite#set_substitute_pattern('file', '^@', '\=getcwd()."/*"', 1)
call unite#set_substitute_pattern('file', '^\\', '~/*')

call unite#set_substitute_pattern('file', '^;v', '~/.vim/*')
call unite#set_substitute_pattern('file', '^;r', '\=$VIMRUNTIME."/*"')
if has('win32') || has('win64')
    call unite#set_substitute_pattern('file', '^;p', 'C:/Program Files/*')
endif

call unite#set_substitute_pattern('file', '\*\*\+', '*', -1)
call unite#set_substitute_pattern('file', '^\~', escape($HOME, '\'), -2)
call unite#set_substitute_pattern('file', '\\\@<! ', '\\ ', -20)
call unite#set_substitute_pattern('file', '\\ \@!', '/', -30)

" ref.vim用設定
AlterCommand ref Ref
let g:ref_cache_dir = $DOTVIM.'/tmp/ref'
let g:ref_use_vimproc = 0
let g:ref_alc_encoding = "Shift_JIS"
let g:ref_alc_use_cache = 1
nnoremap <silent> ma :<C-u>call ref#jump('normal', 'alc', {'noenter': 1})<CR>
vnoremap <silent> ma :<C-u>call ref#jump('visual', 'alc', {'noenter': 1})<CR>
AlterCommand ma :<C-u>Ref alc
AlterCommand mp :<C-u>Ref perldoc

" operator-replace用設定
map R <Plug>(operator-replace)

" quickrun.vim用設定
nnoremap qr :<C-u>QuickRun<Space>
AlterCommand qr QuickRun

" zoom.vim用設定
nnoremap <silent> <C-kPlus> :<C-u>ZoomIn<CR>
nnoremap <silent> <C-kMinus> :<C-u>ZoomOut<CR>
nnoremap <silent> <C-k0> :<C-u>ZoomReset<CR>


set secure

let g:loaded_vimrc = 1
