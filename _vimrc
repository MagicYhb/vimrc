" __  ____   __  __     _____ __  __ ____   ____
"|  \/  \ \ / /  \ \   / /_ _|  \/  |  _ \ / ___|
"| |\/| |\ V /    \ \ / / | || |\/| | |_) | |
"| |  | | | |      \ V /  | || |  | |  _ <| |___
"|_|  |_| |_|       \_/  |___|_|  |_|_| \_\\____|

" Author:       MagicYang <476080754@qq.com>
" Repository:   https://github.com/MagicYhb/vimrc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 通用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                    " set not compatible with the original vi mode, this must be first, because it changes other options as a side effect.
let mapleader = ","                 " set map leader
set laststatus=2                    " always show the statusline, 2总显示最后一个窗口的状态行，1窗口多于一个时显示最后一个窗口的状态行，0不显示最后一个窗口的状态行, 默认值为1
set noeb                            " turn off error prompts
set history=50		                " keep 50 lines of command line history
set ruler		                    " show the cursor position all the time
set showcmd		                    " display incomplete commands
set nu                              " line number
set rnu                             " relative line number
" tab width
set smarttab                        " 在行首输入 tab 时插入宽度为 shiftwidth 的空白，在其他地方按 tabstop 和 softtabstop 处理
set expandtab						" 如果此时需要输入真正的 tab，则输入 Ctrl+V, tab，在 Windows 下是 Ctrl+Q, tab
set tabstop=4                       " 设定 tab 长度为 4
set shiftwidth=4                    " 设定 << 和 >> 命令移动时的宽度为 4
set softtabstop=4                   " 设定编辑模式下 tab 的视在宽度
set updatetime=100                  " 根据光标位置自动更新高亮tag的间隔时间，单位为毫秒
set backspace=indent,eol,start      " allow backspacing over everything in insert mode

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 代码缩进和排版
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nofoldenable                    " 禁用折叠代码
set nowrap                          " 禁止折行

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 代码补全
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set wildmenu                       " vim自身命名行模式智能补全
"set completeopt-=preview           " 补全时不显示窗口，只显示补全列表
set completeopt=longest,menu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 搜索设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set hlsearch                       " 高亮显示搜索结果
set incsearch                       " 开启实时搜索功能
"set ignorecase                     " 搜索时大小写不敏感
set ignorecase smartcase

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 缓存设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set nobackup                       " 设置不备份
"set noswapfile                     " 禁止生成临时文件
if has("vms")
    set nobackup		            " do not keep a backup file, use versions instead
else
    set backup		                " keep a backup file
endif
set autoread                        " 文件在vim之外修改过，自动重新读入
set autowrite                       " 设置自动保存
set confirm                         " 在处理未保存或只读文件的时候，弹出确认

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 编码设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &termencoding=&encoding
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
"set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030
"set fileencodings=cp936,ucs-bom,utf-8
set encoding=utf-8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" inoremap
" i代表是在insert模式下有效
" n代表是在normal模式下有效
" nore表示不递归no recursion
" map映射

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

"nmap <C-w><C-q> <C-w>
nnoremap <C-w><C-q> <C-w>

nnoremap <Enter> yaw

" Delete find pair
nnoremap dy d%

nnoremap <C-j> 5j
nnoremap <C-k> 5k
nnoremap <C-h> 5h
nnoremap <C-l> 5l

" :res[ize] -N / CTRL-W +        使得当前窗口高度加 N (默认值是 1).
nnoremap <F9> :resize -5<CR>

" :res[ize] +N / CTRL-W +        使得当前窗口高度加N (默认值是 1). 
nnoremap <F10> :resize +5<CR>

" CTRL-W <        使得当前窗口宽度减 N (默认值是 1).
nnoremap <F11> <C-w><

" CTRL-W >        使得当前窗口宽度加 N (默认值是 1)。
nnoremap <F12> <C-w>>

" in xshell-5 <C-down> && <C-up> unable to trigger, so use xshell-5 hotkey
"nnoremap <C-down>    5j
"nnoremap <C-up>      5k
"nnoremap <C-left>    5h
"nnoremap <C-right>   5l

" eggcache vim
"nnoremap ; :
:command W w
:command Q q
:command WQ wq
:command Wq wq
:command Qa qa
:command QA qa
:command QW qa

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mouse
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
    "set mouse=a
    "set mousemodel=popup
    "noremap <ScrollWheelDown><ScrollWheelUp> <ScrollWheelDown>
    "noremap <ScrollWheelUp><ScrollWheelUp> <ScrollWheelUp>
"endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlight settings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif
nnoremap <LEADER>3 :set hlsearch<CR>
nnoremap <LEADER>4 :set nohlsearch<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " Make the quickfix window open as the bottommost one
        autocmd FileType qf wincmd J

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        " Also don't do it when the mark is in the first line, that is the default
        " position when opening a file.
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif

    augroup END
else
    " always set autoindenting on
    set autoindent
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" === Install Plugins with vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

""" Color scheme
Plug 'vim-scripts/peaksea'
Plug 'vim-scripts/blackboard.vim'

""" Documents
Plug 'pright/vimcdoc'
Plug 'vim-scripts/stlrefvim'

""" Status line
"Plug 'Lokaltog/vim-powerline', { 'branch': 'develop' }
Plug 'Lokaltog/vim-powerline'
"Plug 'itchyny/lightline.vim'
"Plug 'mengelbrecht/lightline-bufferline'
"Plug 'mgee/lightline-bufferline'

"Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"""
Plug 'michaeljsmith/vim-indent-object'

""" 
Plug 'luochen1990/rainbow'

" general utils
"Plug 'vim-scripts/Tabular'

""" 
Plug 'vim-scripts/YankRing.vim'

""" Tmux
"Plug 'benmills/vimux'
"Plug 'christoomey/vim-tmux-navigator'

"" programming
"Plug 'vim-scripts/UltiSnips'
"
"Plug 'drmingdrmer/xptemplate'
"
"Plug 'MarcWeber/vim-addon-mw-utils' | Plug 'tomtom/tlib_vim' | Plug 'garbas/vim-snipmate'

"Plug 'scrooloose/syntastic'
"Plug 'w0rp/ale'
" 
"Plug 'ludovicchabant/vim-gutentags'

Plug 'mileszs/ack.vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'vim-scripts/visSum.vim'
Plug 'junegunn/vim-easy-align'
Plug 'terryma/vim-multiple-cursors'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'edkolev/tmuxline.vim'
"Plug 'vim-scripts/grep.vim'
Plug 'dkprice/vim-easygrep'
Plug 'mbbill/echofunc'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'scrooloose/nerdcommenter'
"" Plug 'vim-scripts/pep8'
Plug 'pright/vim-snippets'
Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'mattn/emmet-vim'

""" File navigation
"Plug 'vim-scripts/Command-T'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"Plug 'yuki-ycino/fzf-preview.vim'
"Plug 'vim-scripts/minibufexpl.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }

"Plug 'MattesGroeger/vim-bookmarks'

""" preview
"Plug 'ryanoasis/vim-devicons'

""" Indent
Plug 'michaeljsmith/vim-indent-object'
Plug 'Yggdroot/indentLine'
Plug 'nathanaelkane/vim-indent-guides'

""" Translator
""" use coc-translator
"Plug 'voldikss/vim-translator'
Plug 'soimort/translate-shell'

""" Key word
Plug 'itchyny/vim-cursorword'
Plug 'lfv89/vim-interestingwords'

"""  Git
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
"if has('nvim') || has('patch-8.0.902')
    "Plug 'mhinz/vim-signify'
"else
    "Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
"endif

""" term need vim8.2
Plug 'voldikss/vim-floaterm'

""" Undo tree
Plug 'mbbill/undotree'

""" Shell
"Plug 'edkolev/promptline.vim'

""" viewer
Plug 'liuchengxu/vim-which-key'

""" C/C++
Plug 'vim-scripts/a.vim', { 'for': ['c', 'cpp'] }

""" Json
Plug 'elzr/vim-json', { 'for': 'json' }

""" Python
"Plug 'davidhalter/jedi-vim', { 'do': 'git submodule update --init', 'for': 'python' }
"Plug 'tmhedberg/SimpylFold', { 'for' :['python', 'vim-plug'] }
"Plug 'vim-scripts/indentpython.vim', { 'for' :['python', 'vim-plug'] }
"Plug 'plytophogy/vim-virtualenv', { 'for' :['python', 'vim-plug'] }
"Plug 'Vimjas/vim-python-pep8-indent', { 'for' :['python', 'vim-plug'] }
"Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins', 'for' :['python', 'vim-plug'] }
"Plug 'tweekmonster/braceless.vim', { 'for' :['python', 'vim-plug'] }

""" Auto complete
"Plug 'Valloric/YouCompleteMe'
"Plug 'vim-scripts/code_complete'
"Plug 'vim-scripts/OmniCppComplete', { 'for': ['c', 'cpp'] }
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc.nvim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_global_extensions = [
    \ 'coc-css',
    \ 'coc-translator',
    \ 'coc-python',
    "\ 'coc-pyright',
    "\ 'coc-jedi',
    "\ 'coc-html',
    \ 'coc-json',
    "\ 'coc-sh',
    \ 'coc-clangd',
    \ 'coc-vimlsp']

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#pum#visible() ? "\<C-n>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! Show_documentation()
	call CocActionAsync('highlight')
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
nnoremap <LEADER>e :call Show_documentation()<CR>

" coc translator
" popup
nmap ts <Plug>(coc-translator-p)
vmap ts <Plug>(coc-translator-pv)
" echo
nmap te <Plug>(coc-translator-e)
vmap te <Plug>(coc-translator-ev)
" replace
"nmap <LEADER>tsr <Plug>(coc-translator-r)
"vmap <LEADER>tsr <Plug>(coc-translator-rv)

" nnoremap <silent><nowait> <LEADER>d :CocList diagnostics<cr>

"let s:script_cwd = expand('<sfile>:p:h')
"let s:source_list = [
      "\ 'viml',
      "\ 'config',
      "\]

"for s:item in s:source_list
  "let s:path = split(globpath(s:script_cwd . '/' . s:item, '*.vim'), '\n')
  "for s:cfg in s:path
    "if filereadable(s:cfg)
      "execute 'source ' . s:cfg
    "endif
  "endfor
"endfor

"unlet s:script_cwd
"unlet s:source_list

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-translator
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration
"let g:translator_target_lang='zh'
"let g:translator_source_lang='auto'
"let g:translator_default_engines=['youdao', 'bing', 'google', 'haici']
" Available: 'bing', 'google', 'haici', 'iciba'(expired), 'sdcv', 'trans', 'youdao'
" Default: If g:translator_target_lang is 'zh', this will be ['bing', 'google', 'haici', 'youdao'], otherwise ['google']

" echo translation in the cmdline
"nmap <silent> <Leader>t <Plug>Translate
"vmap <silent> <Leader>t <Plug>TranslateV

"nmap <silent> <Leader>t <Plug>TranslateW
"vmap <silent> <Leader>t <Plug>TranslateWV

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-which-key
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set timeoutlen=500
nnoremap <silent> <leader> :WhichKey ','<CR>
let g:mapleader = ','
let g:maplocalleader = "\<Space>"

"nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
"nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

"nnoremap <silent> <leader>       :<c-u>WhichKey  ','<CR>
"nnoremap <silent> <localleader>  :<c-u>WhichKey '<Space>'<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-floaterm need vim 82
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Configuration
" Set floaterm window's background to black
 "hi Floaterm guibg=black
" " Set floating window border line color to cyan, and background to orange
 hi FloatermBorder guibg=orange guifg=cyan

let g:floaterm_title = '------------------------------------------------ MagicYang floaterm: $1/$2 '
let g:floaterm_width = 0.65
let g:floaterm_height = 0.70
let g:floaterm_wintype = 'float'
"let g:floaterm_position = 'topleft'
let g:floaterm_position = 'topright'
"let g:floaterm_opener
"let g:floaterm_autoclose
"let g:floaterm_borderchars
"let g:floaterm_autoclose = 1
let g:floaterm_borderchars = '-]-[[]]['

" KeyMaps
let g:floaterm_keymap_new = '<F5>c'
let g:floaterm_keymap_prev = '<F5>p'
let g:floaterm_keymap_next = '<F5>n'
let g:floaterm_keymap_first = '<F5>f'
let g:floaterm_keymap_last = '<F5>l'
let g:floaterm_keymap_hide = '<F5>h'
let g:floaterm_keymap_show = '<F5>s'
let g:floaterm_keymap_kill = '<F5>q'
let g:floaterm_keymap_toggle = '<Leader>t'

" 绑定 Ctrl + b 到 floaterm 向上翻页
tnoremap <C-k> <C-\><C-n><C-u>
" 绑定 Ctrl + f 到 floaterm 向下翻页
tnoremap <C-j> <C-\><C-n><C-d>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-devicons
"let g:WebDevIconsUnicodeDecorateFolderNodes = 1
"let g:DevIconsEnableFolderExtensionPatternMatching = 1
"let g:DevIconsEnableFileTypeDetection = 1
"let g:DevIconsEnableFolderOpenCloseFolderSymbol = '▾'
"let g:DevIconsEnableFolderCloseFolderSymbol = '▸'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color
if $TERM!="linux"
    if !has("gui_running")
        "set term=xterm
        set t_Co=256
    else
        set guioptions-=T
        set guifont=Monaco
    endif

    set background=dark
    colorscheme peaksea
else
    colorscheme blackboard
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" quickfix是vim内置插件，用于浏览命令执行结果信息。命令需要进行设定，才能把执行结果显示到quickfix中。
" QuickFix
"nnoremap <silent> <leader>n :cn<CR>
"nnoremap <silent> <leader>p :cp<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimcdoc
" Set the language in help files
set helplang=cn

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NerdTree
"打开vim时如果没有文件自动打开NERDTree
" autocmd vimenter * if !argc()|NERDTree|endif
"当NERDTree为剩下的唯一窗口时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let NERDTreeWinPos="left"
let g:NERDTreeWinSize = 45          " 设定 NERDTree 视窗大小
" let g:NERDTreeHidden=0            " 不显示隐藏文件
let g:NERDTreeShowLineNumbers=1     " 是否显示行号
" let NERDTreeIgnore = ['\.pyc$']     " 过滤所有.pyc文件不显示

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

nnoremap <silent> <F3> :NERDTreeToggle<CR>
nnoremap <silent> <F7> :NERDTreeFind<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tagbar
let g:tagbar_sort = 0
let g:tagbar_left = 0
let g:tagbar_width= 35
nnoremap <silent> <F4> :TagbarToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" taglist
"let Tlist_Show_One_File=1
"let Tlist_Exit_OnlyWindow=1
"let Tlist_Use_Right_Window=1
"nnoremap <silent> <F3> :TlistToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" winmanager
"let g:winManagerWindowLayout='FileExplorer|TagList'
"let g:winManagerOnRightSide=1
"nnoremap <silent> wm :WMToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope
if has("cscope")
    set csprg=/usr/bin/cscope
    set csto=0
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
        " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif

command! -nargs=* -complete=command Cs cs <args>
command! -nargs=* -complete=command CS cs <args>


" cscope 命令:
" add  :  添加新的数据库                 (用法: add file|dir [pre-path] [flags])
" find :  查询一个模式                   (用法: find a|c|d|e|f|g|i|s|t name)
"         a: 搜索对此符号的赋值
"         c: 搜索调用此函数的函数
"         d: 搜索此函数调用的函数
"         e: 搜索此 egrep 模式
"         f: 搜索此文件
"         g: 搜索此定义
"         i: 搜索包含此文件的文件
"         s: 搜索此 C 符号
"         t: 搜索此文本字符串
" help : 显示此信息                     (用法: help)
" kill : 结束一个连接                   (用法: kill #)
" reset: 重置所有连接                   (用法: reset)
" show : 显示连接                       (用法: show)

""" :set cscopequickfix=s-,c-,d-,i-,t-,e-
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>

nmap fs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap fg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap fc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap ft :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap fe :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap ff :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap fi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap fd :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap fa :cs find a <C-R>=expand("<cword>")<CR><CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ctags
"set tags+=~/.vim/bundle/stl-tags/tags
"set tags+=~/.vim/bundle/glibc-tags/tags
"set tags+=~/.vim/bundle/mytags/hi3716c_sdk50_framework_base.tags
if filereadable("tags")
    set tags+=tags
endif

"nnoremap <silent> <leader>u :!update_tags<CR>:cs reset<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentLine
let g:indent_guides_guide_size  = 1     "指定对其的尺寸
let g:indent_guides_start_level = 2     "从第二层开始可视化缩进

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" minibufexpl
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplModSelTarget=1
" let g:miniBufExplForceSyntaxEnable = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 头文件(.h)和源文件(.c,.cpp,.cc...)之间切换
" a.vim
nnoremap <silent> <leader>a :A<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" grep.vim
"if !executable('ag')
    "let Grep_Default_Filelist = '*.c *.cpp *.h'
    "let Grep_Skip_Files = '*.bak *~'
    "let Grep_Default_Options = '-i'
    "nnoremap <silent> <F11> :Rgrep<CR>
"endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ack.vim
if executable('ag')
    "let g:ackprg = 'ag --vimgrep'
    let g:ackprg = 'ag -f -i --nogroup --nocolor --column'
    let g:ackhighlight = 1
    "nnoremap <F12> :Ack!<Space><C-R><C-W>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OmniCppComplete
"let OmniCpp_GlobalScopeSearch = 1
"let OmniCpp_NamespaceSearch = 1
"let OmniCpp_DisplayMode = 1
"let OmniCpp_ShowScopeInAbbr = 0
"let OmniCpp_ShowPrototypeInAbbr = 1
"let OmniCpp_ShowAccess = 1
"let OmniCpp_MayCompleteDot = 1
"let OmniCpp_MayCompleteArrow = 1
"let OmniCpp_MayCompleteScope = 1
""set foldmethod=syntax
"set foldmethod=indent
""set foldmethod=marker
"set foldlevel=100

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" echofunc
let g:EchoFuncKeyPrev="<C-->"
let g:EchoFuncKeyNext="<C-+>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lookupfile
"let g:LookupFile_MinPatLength = 2               "最少输入2个字符才开始查找
"let g:LookupFile_PreserveLastPattern = 0        "不保存上次查找的字符串
"let g:LookupFile_PreservePatternHistory = 1     "保存查找历史
"let g:LookupFile_AlwaysAcceptFirst = 1          "回车打开第一个匹配项目
"let g:LookupFile_AllowNewFiles = 0              "不允许创建不存在的文件
"if filereadable("./filenametags")                "设置tag文件的名字
"let g:LookupFile_TagExpr = '"./filenametags"'
"endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DoxygenToolkit
let g:DoxygenToolkit_briefTag_pre="@Synopsis "
let g:DoxygenToolkit_paramTag_pre="@Param "
let g:DoxygenToolkit_returnTag="@Returns"
let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="--------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="MagicYang"
"let g:DoxygenToolkit_licenseTag="My own license"   <-- !!! Does not end with "\<enter>"
let g:doxygenToolkit_briefTag_funcName="yes"
nnoremap <F9>a :DoxAuthor
nnoremap <F9>f :Dox
nnoremap <F9>b :DoxBlock
nnoremap <F9>c O/** */<Left><Left>
nnoremap <F9>l :DoxLic


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" YankRing
let g:yankring_history_file = '.yankring_history'
nnoremap <silent> <F6> :YRShow<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CCTree
"let g:CCTreeCscopeDb = "cscope.out"
" using my own command to generate cctree.out because cctree cannot parse the
" one which ccglue generates.
"" nnoremap <silent> <F10> :MyCCTreeLoadXRefDB<CR>
"" nnoremap <silent> <F10>r :MyCCTreeLoadDB<CR>
"" 
"" command! -nargs=0 MyCCTreeLoadXRefDB call MyCCTreeLoadDBFunc(0)
"" command! -nargs=0 MyCCTreeLoadDB call MyCCTreeLoadDBFunc(1)
"" 
"" function! MyCCTreeLoadDBFunc(rebuild)
""     if a:rebuild==1 || !filereadable("cctree.out")
""         :CCTreeLoadDB cscope.out
""         :CCTreeSaveXRefDB cctree.out
""     else
""         :CCTreeLoadXRefDBFromDisk cctree.out
""     endif
"" endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" undotree
" Maintain undo history between sessions
set undofile
set undodir=~/.vim/undodir
"nnoremap <F5> :UndotreeToggle<CR>
noremap L :UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 8
let g:undotree_SplitWidth = 24

" ==
" == GitGutter
" ==
" let g:gitgutter_signs = 0
let g:NERDTreeGitStatusPorcelainVersion = 1
let g:gitgutter_sign_allow_clobber = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_preview_win_floating = 1
"let g:gitgutter_sign_added = '▎'
"let g:gitgutter_sign_modified = '░'
"let g:gitgutter_sign_removed = '▏'
"let g:gitgutter_sign_removed_first_line = '▔'
"let g:gitgutter_sign_modified_removed = '▒'
" autocmd BufWritePost * GitGutter
nnoremap <LEADER>gf :GitGutterFold<CR>
nnoremap H :GitGutterPreviewHunk<CR>
nnoremap <LEADER>g- :GitGutterPrevHunk<CR>
nnoremap <LEADER>g= :GitGutterNextHunk<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " TaskList
" let g:tlWindowPosition = 1
" map <leader>v <Plug>TaskList

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" pep8
" let g:pep8_map='<leader>8'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gist-vim
let g:gist_detect_filetype = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
"nmap ga <Plug>(EasyAlign)
"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

"let g:syntastic_c_checkers = []
"let g:syntastic_cpp_checkers = []
"let g:syntastic_java_checkers = []
"let g:syntastic_python_checkers = ['python']
"let g:syntastic_sh_checkers = ['sh', 'shellcheck']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-airline
let g:airline#extensions#whitespace#enabled = 0         " 关闭空白符检测
let g:airline_theme = 'dark'                            " 设置主题
let g:airline_powerline_fonts = 1                       " 使用powerline的字体
let g:airline_skip_empty_sections = 1                   " 跳过空的状态栏部分，避免色块残留的问题

"" enable tabline
let g:airline#extensions#tabline#enabled = 1            " tabline使能
let g:airline_stl_path_style = 'short'
let g:airline#extensions#tabline#left_sep = ' '         " tabline中当前buffer两端的分隔字符
let g:airline#extensions#tabline#left_alt_sep = '|'     " tabline中未激活buffer两端的分隔字符
let g:airline#extensions#tabline#buffer_nr_show = 1     " tabline中buffer显示编号 

nmap <leader>1 <Plug>AirlineSelectPrevTab               " 切换到前一个tab
nmap <leader>2 <Plug>AirlineSelectNextTab               " 切换到下一个tab
nmap <leader>q :bp<cr>:bd #<cr>                         " 退出当前的 tab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fzf.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting ag as the default source for fzf
if executable('ag')
    let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g  ""'
endif

" This is the default extra key bindings
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~45%' }

" This is the default option:
"   - Preview window on the right with 50% width
"   - CTRL-/ will toggle preview window.
" - Note that this array is passed as arguments to fzf#vim#with_preview function.
" - To learn more about preview window options, see `--preview-window` section of `man fzf`.
let g:fzf_preview_window = ['right:35%:hidden', 'ctrl-/']
"let g:fzf_preview_command = 'bat --color=always --style=numbers --line-range :500 {}'
"let g:fzf_preview_options = ['--preview', 'cat {}']
" let g:fzf_preview_filetypes = ['c', 'cpp', 'txt', 'md', 'html', 'css', 'js', 'py', 'sh', 'yaml', 'json']

" Preview window on the upper side of the window with 40% height,
" hidden by default, ctrl-/ to toggle
"let g:fzf_preview_window = ['up:30%:hidden', 'ctrl-/']
"let g:fzf_preview_window = ['up:30%', 'ctrl-/']

" Empty value to disable preview window altogether
"let g:fzf_preview_window = []

" preview in marw window
" let g:fzf_preview_mark = 'echo {} | sed 's/:/ /' | xargs -I{} sh -c "bat {}; echo"'
" let g:fzf_preview_mark = 'echo {} | xargs -I{} sh -c "bat {}; echo"'

" Customize fzf colors to match your color scheme
let g:fzf_colors = {
            \ 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'update_tags'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
            \ call fzf#vim#ag(<q-args>,
            \                 <bang>0 ? fzf#vim#with_preview('up:60%')
            \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
            \                 <bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-p> <plug>(fzf-complete-path)
imap <c-x><c-f> <plug>(fzf-complete-file)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-buffer-line)

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

""""""""""""""""""""""""""""""""""
":Files [PATH]	    Files (runs $FZF_DEFAULT_COMMAND if defined)
":GFiles [OPTS]	    Git files (git ls-files)
":GFiles?	        Git files (git status)
":Buffers	        Open buffers
":Colors	        Color schemes
":Ag [PATTERN]	    ag search result (ALT-A to select all, ALT-D to deselect all)
":Rg [PATTERN]	    rg search result (ALT-A to select all, ALT-D to deselect all)
":Lines [QUERY]	    Lines in loaded buffers
":BLines [QUERY]	Lines in the current buffer
":Tags [QUERY]	    Tags in the project (ctags -R)
":BTags [QUERY]	    Tags in the current buffer
":Marks	            Marks
":Windows	        Windows
":Locate PATTERN	locate command output
":History	        v:oldfiles and open buffers
":History:	        Command history
":History/	        Search history
":Snippets	        Snippets (UltiSnips)
":Commits	        Git commits (requires fugitive.vim)
":BCommits	        Git commits for the current buffer; visual-select lines to track changes in the range
":Commands	        Commands
":Maps              Normal mode mappings
":Helptags	        Help tags 1
":Filetypes	        File types

nnoremap <silent> <leader>f :Files<CR>
"nnoremap <silent> <leader>t :BTags<CR>
nnoremap <silent> <leader>T :Tags<CR>
nnoremap <silent> <leader>h :History<CR>
nnoremap <silent> <leader>H :History:<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>g :Ag<CR>
nnoremap <silent> <leader>G :Ag!<CR>
nnoremap <silent> <leader>m :Marks<CR>
nnoremap <silent> <leader>n :Marks<CR>
nnoremap <silent> <leader>w :Windows<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimux
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:VimuxHeight = "30"
" let g:VimuxOrientation = "h"
" 
" function! VimuxSlime()
"     call VimuxSendText(@v)
"     call VimuxSendKeys("Enter")
" endfunction
" 
" " If text is selected, save it in the v buffer and send that buffer it to tmux
" vmap <Leader>vs "vy :call VimuxSlime()<CR>
" 
" " Select current paragraph and send it to tmux
" nmap <Leader>vs vip<Leader>vs<CR>
" 
" " Prompt for a command to run
" map <Leader>vp :VimuxPromptCommand<CR>
" map <Leader>vm :VimuxPromptCommand("make ")<CR>
" 
" " Run last command executed by VimuxRunCommand
" map <Leader>vl :VimuxRunLastCommand<CR>
" 
" " Inspect runner pane
" map <Leader>vi :VimuxInspectRunner<CR>
" 
" " Close vim tmux runner opened by VimuxRunCommand
" map <Leader>vq :VimuxCloseRunner<CR>
" 
" " Interrupt any command running in the runner pane
" map <Leader>vx :VimuxInterruptRunner<CR>
" 
" " Zoom the runner pane (use <bind-key> z to restore runner pane)
" map <Leader>vz :call VimuxZoomRunner()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-table-mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:table_mode_corner='|'
let g:table_mode_corner_corner = '+'
"let g:table_mode_header_fillchar='='

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdcommenter
" 注释工具
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <leader> + <c> + <space>
let g:NERDCustomDelimiters = {
            \ 'asm': { 'left': '/*', 'right': '*/' }
            \ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" rainbow
" 提供嵌套括号高亮
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 1
let g:rainbow_conf = {
\ 'guifgs': ['darkorange3', 'seagreen3', 'royalblue3', 'firebrick'],
\ 'ctermfgs': ['lightyellow', 'lightcyan','lightblue', 'lightmagenta'],
\ 'operators': '_,_',
\ 'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\ 'separately': {
\ '*': {},
\ 'tex': {
\ 'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\ },
\ 'lisp': {
\ 'guifgs': ['darkorange3', 'seagreen3', 'royalblue3', 'firebrick'],
\ },
\ 'vim': {
\ 'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\ },
\ 'html': {
\ 'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\ },
\ 'css': 0,
\ }
\}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" promptline.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:promptline_preset = 'clear'
" let g:promptline_preset = {
"             \'b' : [ promptline#slices#python_virtualenv(), '$USER' ],
"             \'a' : [ promptline#slices#vcs_branch() ],
"             \'c' : [ promptline#slices#cwd() ],
"             \'options': {
"             \'left_sections' : [ 'b', 'a', 'c' ],
"             \'left_only_sections' : [ 'b', 'a', 'c' ]}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tmuxline.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tmuxline_preset = 'tmux'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-gutentags
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gutentags_modules = []
if executable('ctags')
    let g:gutentags_modules += ['ctags']
endif
if executable('cscope')
    let g:gutentags_modules += ['cscope']
endif
if executable('gtags-cscope') && executable('gtags')
    let g:gutentags_modules += ['gtags_cscope']
endif

let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" new file title
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()"
""定义函数SetTitle，自动插入文件头
func SetTitle()
	"如果文件类型为.sh文件
	if &filetype == 'sh'
		call setline(1,"\#!/bin/bash")
		call append(line("."), " ")
		call append(line(".")+1, "\#> File Name:        ".expand("%"))
		call append(line(".")+2, "\#> Author:           MagicYang")
		call append(line(".")+3, "\#> Version:          1.0.1")
		call append(line(".")+4, "\#> Mail:             476080754@qq.com")
		call append(line(".")+5, "\#> Created Time:     ".strftime("%Y-%m-%d %H:%M:%S"))
		call append(line(".")+6, " ")
		call append(line(".")+7, "")
    elseif &filetype == 'python'
        call setline(1,"#!/usr/bin/env python")
        call append(line("."),"# coding=utf-8")
	    call append(line(".")+1, "")

    elseif &filetype == 'ruby'
        call setline(1,"#!/usr/bin/env ruby")
        call append(line("."),"# encoding: utf-8")
	    call append(line(".")+1, "")

"    elseif &filetype == 'mkd'
"        call setline(1,"<head><meta charset=\"UTF-8\"></head>")
	else
		call setline(1, "/*************************************************************************")
		call append(line("."), "	> File Name:        ".expand("%"))
		call append(line(".")+1, "	> Author:           MagicYang")
		call append(line(".")+2, "	> Version:          1.0.1")
		call append(line(".")+3, "	> Mail:             476080754@qq.com")
		call append(line(".")+4, "	> Created Time:     ".strftime("%Y-%m-%d %H:%M:%S"))
		call append(line(".")+5, "	> par Copyright (c):")
		call append(line(".")+6, "")
		call append(line(".")+7, "	> par History:     ")
		call append(line(".")+8, "	> |  version  |    author    |     desc     |       data")
		call append(line(".")+9, "	> |  1.0.1    |   MagicYang  |  create file |       ".strftime("%Y-%m-%d"))
		call append(line(".")+10, " ************************************************************************/")
		call append(line(".")+11, "")
	endif
	if expand("%:e") == 'cpp'
		call append(line(".")+12, "#include <iostream>")
		call append(line(".")+13, "using namespace std;")
		call append(line(".")+14, "")
	endif
	if &filetype == 'c'
		call append(line(".")+12, "#include <stdio.h>")
		call append(line(".")+13, "")
	endif
	if expand("%:e") == 'h'
		call append(line(".")+12, "#ifndef _".toupper(expand("%:r"))."_H")
		call append(line(".")+13, "#define _".toupper(expand("%:r"))."_H")
        call append(line(".")+14, "")
        call append(line(".")+15, "#ifdef __cplusplus")
        call append(line(".")+16, "extern \"C\" {")
        call append(line(".")+17, "#endif")
        call append(line(".")+18, "")
        call append(line(".")+19, "")
        call append(line(".")+20, "")
        call append(line(".")+21, "#ifdef __cplusplus")
        call append(line(".")+22, "}")
        call append(line(".")+23, "#endif")
        call append(line(".")+24, "")
        call append(line(".")+25, "#endif")
	endif
	if &filetype == 'java'
		call append(line(".")+12,"public class ".expand("%:r"))
		call append(line(".")+13,"")
	endif
	"新建文件后，自动定位到文件末尾
endfunc
autocmd BufNewFile * normal G

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" add cscope.out   
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" echo 'vim:('$VIM')'

if exists('$VIM')
    if $VIM == '/usr/local/share/vim'
    " 对于经典vim的配置
        if filereadable("cscope/load.vim")
            source ./cscope/load.vim
        endif
    else
    " 对于neovim的配置
    endif
endif
