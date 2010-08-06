" vim:set ts=4 sts=4 sw=4 tw=0: (���̍s�Ɋւ��Ă�:help modeline���Q��)
if !exists('g:loaded_vimrc')
    let g:loaded_vimrc = 0
endif

" <Leader>��'\'�̑����'m'���g����悤�ɂ���
let mapleader = 'm'
let g:mapleader = 'm'
let g:maplocalleader = ','
" <Leader>.�ő�����vimrc���J����悤�ɂ���
nnoremap <Leader>. :<C-u>edit $MYVIMRC<CR>
" :ReloadVimrc�R�}���h�̒ǉ�
command! ReloadVimrc  source $MYVIMRC

" �����ݒ� {{{
set nocompatible
filetype plugin indent on
if has('win32') || has('win64')
    set shellslash
endif
call altercmd#load()
" }}}

"-- 
" ���{��p�G���R�[�h�ݒ�{{{
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
source $VIMRUNTIME/delmenu.vim
set langmenu=menu_ja_jp.utf-8.vim
source $VIMRUNTIME/menu.vim

" modeline����fenc���w�肳��Ă���ꍇ�̑Ή� {{{
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
" �v���b�g�t�H�[���ˑ��̖��ׂ̈̐ݒ� {{{
" Windows/Linux�ɂ����āA.vim��$VIM/vimfiles�̈Ⴂ���z������ {{{
if has('win32') || has('win64')
    let $DOTVIM = $VIM."/vimfiles"
else
    let $DOTVIM = $HOME."/.vim"
endif
" }}}

" �t�@�C�����ɑ啶���������̋�ʂ��Ȃ��V�X�e���p�̐ݒ� {{{
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
    set tags=./tags,tags
endif
" }}}

" �R���\�[���łŊ��ϐ�$DISPLAY���ݒ肳��Ă���ƋN�����x���Ȃ錏�֑Ή� {{{
if !has('gui_running') && has('xterm_clipboard')
    set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif
" }}}

" Win�ł�PATH��$VIM���܂܂�Ă��Ȃ��Ƃ���exe�������o���Ȃ��̂ŏC�� {{{
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
    let $PATH = $VIM . ';' . $PATH
endif
" }}}

" Mac�ł̓f�t�H���g��'iskeyword'��cp932�ɑΉ�������Ă��Ȃ��̂ŏC�� {{{
if has('mac')
    set iskeyword=@,48-57,_,128-167,224-235
endif
" }}}

" helptags�̐��� {{{
if has('mac')
    helptags ~/.vim/doc/
elseif has('win32')
    helptags ~/vimfiles/doc/
endif
" }}}
" }}}

"-- 
" GUI�ŗL�ł͂Ȃ���ʕ\���̐ݒ� {{{
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
" �s���� h �������ƑI��͈͂Ɋ܂܂��܏�����
vnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
" �܏��� l �������ƑI��͈͂Ɋ܂܂��܏���J��
vnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'

" ���݂�fold�̂݊J������Ԃɂ���
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
" �}�E�X�Ɋւ���ݒ� {{{
set mouse=a
" }}}

"-- 
" �ҏW�Ɋւ���ݒ� {{{
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

" ���e�����.txt�t�@�C����ۑ������玩���ō폜���� {{{
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
" �����̋����Ɋւ���ݒ� {{{
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
" Change Directory�Ɋւ���ݒ� {{{
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
" �J�����g�f�B���N�g�����t�@�C���Ɠ����f�B���N�g���Ɉړ�����
AlterCommand cd CD

" }}}

"-- 
" �o�C�i���̕ҏW�Ɋւ���ݒ� {{{
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
" ���o�b�t�@�̍����\�� {{{
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
" �t�@�C���܂��̓o�b�t�@�ԍ����w�肵�č����\�����A#�Ȃ痠�o�b�t�@�Ɣ�r
command! -nargs=? -complete=file Diff if '<args>'=='' | browse vertical diffsplit|else| vertical diffsplit <args>|endif
" }}}

"-- 
" Sticky Shift���������� {{{
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
" �}�b�v��` {{{
" Normal���[�h {{{
nnoremap M m

" Window�֌W {{{
set splitbelow
set splitright
"�f�t�H���g�̍ŏ� window ������0��
set winminheight=0
" Ctrl-j/k/h/l �ŏ㉺���E��Window�ֈړ�
nmap <C-j> <C-W>j<C-W>_
nmap <C-k> <C-W>k<C-W>_
nmap <C-h> <C-W>h<C-W>_
nmap <C-l> <C-W>l<C-W>_

" ��ʕ����p�̃L�[�}�b�v
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

" Buffer�֌W {{{
" H�őO�̃o�b�t�@��\��
nnoremap H :<C-u>bp<CR>
" L�Ŏ��̃o�b�t�@��\��
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

" �ҏW���o�b�t�@��ʂ̒P�ƃ^�u�ɐ؂�o�� {{{
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

" Tab�֌W {{{
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
" GNU screen���Ƀ^�u���ړ�
for i in range(10)
  execute 'nnoremap <silent>' ('[Tabbed]'.(i))  ((i+1).'gt')
endfor
unlet i
" }}}

" Debug�֌W {{{
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

" help�֌W
" Execute help by cursor keyword.
nnoremap <silent> g<C-h>  :<C-u>help<Space><C-r><C-w><CR>
" Grep in help.
nnoremap grh  :<C-u>Hg<Space>
" }}}

" Visual���[�h {{{
" <CR>��change�ɂ���
xnoremap <CR> c
" <Tab>��indent�ɂ���
xnoremap <Tab> >
" <S-Tab>��unindent�ɂ���
xnoremap <S-Tab> <
" Visual���[�h��*�őI��͈͂���������
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>
" }}}

" Insert���[�h {{{
" <C-t>��Tab�ɂ���
inoremap <C-t> <C-v><Tab>
" <C-d>��Del�ɂ���
inoremap <C-d> <Del>
" <C-a>�Ő擪�Ɉړ�����
inoremap <silent><C-a> <C-o>^
" <C-e>�ōŌ�Ɉړ�����
inoremap <silent><C-e> <C-o>$
" <C-f>, <C-b>�Ńy�[�W���ړ�����
inoremap <expr><C-f>  pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b>  pumvisible() ? "\<PageUp>"   : "\<Left>"
" <A-h>�őO�Ɉړ�����
inoremap <A-h>  <Left>
" <A-l>�Ŏ��Ɉړ�����
inoremap <A-l>  <Right>
" <A-k>�őO�s�Ɉړ�����
inoremap <A-k>  <Up>
" <A-j>�Ŏ��s�Ɉړ�����
inoremap <A-j>  <Down>
" <C-u>��undo����
inoremap <C-u>  <C-g>u<C-u>
" <C-h>, <BS>, <Space>�Ń|�b�v�A�b�v������
inoremap <expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
inoremap <expr><BS> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() . ' ' : ' '
" ���ʂ���͂������ɃJ�[�\����^�񒆂�
inoremap () ()<LEFT>
inoremap [] []<LEFT>
inoremap {} {}<LEFT>
inoremap <> <><LEFT>
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>
" }}}

" Command-line���[�h {{{
" <C-d>��Del�ɂ���
cnoremap <C-d>          <Del>
" <C-a>�Ő擪�Ɉړ�����
cnoremap <C-a>          <Home>
" <C-e>�ōŌ�Ɉړ�����
cnoremap <C-e>          <End>
" <C-n>, <C-p>�ŃR�}���h����
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
" <C-s>�ŃR�}���h������\������
cnoremap <C-s> <C-f>
" <C-l>�ŕ⊮���������X�g
cnoremap <C-l> <C-d>
" <A-h>�őO�̌��t�Ɉړ�����
cnoremap <A-h>  <S-Left>
" <A-l>�Ŏ��̌��t�Ɉړ�����
cnoremap <A-l>  <S-Right>
" }}}

" ���W�X�^�p�L�[�}�b�v {{{
" <Leader>m�Ń}�[�N���e���m�F
nnoremap <Leader>m  :<C-u>marks<CR>
" <Leader>q�Ń��W�X�^���e���m�F
nnoremap <Leader>q  :<C-u>registers<CR>
" }}}

" �w���v�R�}���h�p�L�[�}�b�v {{{
nnoremap t <Nop>
" tj�ŃW�����v
nnoremap tj <C-]>
" tl�Ői��
nnoremap tl :<C-u>tag<CR>
" th�Ŗ߂�
nnoremap th :<C-u>pop<CR>
" tl�ŗ����ꗗ
nnoremap tl :<C-u>tags<CR>
" }}}

" �����R�[�h���w�肵�ĊJ������ {{{
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

" �t�@�C���^�C�v��ύX {{{
nmap <Leader>ew :<C-u>set fileformat=dos<CR>
nmap <Leader>ea :<C-u>set fileformat=mac<CR>
nmap <Leader>eu :<C-u>set fileformat=unix<CR>
" }}}
" }}}

"-- 
" Plug-in�p�ݒ� {{{
" Plug-in�t�H���_�����������Ȃ����A�g���Ă݂����ꍇ�̐ݒ� {{{
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

" netrw�p�ݒ� {{{
" <C-h>�ŏ�̃f�B���N�g���Ɉړ�
augroup NetrwCommand
    autocmd!
    autocmd FileType netrw nmap <buffer> <C-h> -
augroup END
" }}}

" quickrun.vim�p�ݒ� {{{
AlterCommand qr QuickRun
" }}}

" operator-replace�p�ݒ� {{{
map R <Plug>(operator-replace)
" }}}

" neocomplcache.vim�p�ݒ� {{{
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

" skk.vim�p�ݒ� {{{
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

" vimshell.vim�p�ݒ� {{{
AlterCommand vsh VimShell
AlterCommand vshp VimShellPop
let g:vimshell_temporary_directory = $HOME."/vimfiles"
let g:vimshell_prompt = $USERNAME.">"
let g:vimshell_user_prompt = 'getcwd()'
let g:vimshell_max_list = 15
let g:vimshell_smart_case = 1
let g:vimshell_interactive_encodings = {'telnet':'cp932'}
let g:vimshell_execute_file_list = {}
call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
let g:vimshell_execute_file_list['pl'] = 'perl'
call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
" }}}
" }}}


set secure

let g:loaded_vimrc = 1
