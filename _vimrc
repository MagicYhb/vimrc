"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Global settings
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" set compatible 就是让 vim 关闭所有扩bai展的功能，尽du量模拟 vi 的行为。
" set nocompatible，关闭兼容模式。由于这个选项是最最基础的选项，会连带很多其它选项发生变动（称作副作用），所以它必需是第一个设定的选项。
set nocompatible

" Always show the statusline
" 2总显示最后一个窗口的状态行，1窗口多于一个时显示最后一个窗口的状态行，0不显示最后一个窗口的状态行, 默认值为1
set laststatus=2

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
    set nobackup		" do not keep a backup file, use versions instead
else
    set backup		    " keep a backup file
endif

set history=50		    " keep 50 lines of command line history
set ruler		        " show the cursor position all the time
set showcmd		        " display incomplete commands
set incsearch		    " do incremental searching

set nu                  " line number
set rnu                 " relative line number

" tab width
set smarttab            " 在行首输入 tab 时插入宽度为 shiftwidth 的空白，在其他地方按 tabstop 和 softtabstop 处理
set expandtab           " 如果此时需要输入真正的 tab，则输入 Ctrl+V, tab，在 Windows 下是 Ctrl+Q, tab
set tabstop=4           " 设定 tab 长度为 4
set shiftwidth=4        " 设定 << 和 >> 命令移动时的宽度为 4
set softtabstop=4       " 设定编辑模式下 tab 的视在宽度

set updatetime=100      "根据光标位置自动更新高亮tag的间隔时间，单位为毫秒

" encoding
let &termencoding=&encoding
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
"set fileencoding=cp936
"set fileencodings=cp936,ucs-bom,utf-8
set encoding=utf-8

set completeopt=longest,menu

set ignorecase smartcase

let mapleader = ","

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" inoremap
" i代表是在插入模式（insert）下有效
" nore表示不递归no recursion
" map映射

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
    "set mouse=a
"endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

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
" vim-plug
call plug#begin('~/.vim/plugged')

" color scheme
Plug 'vim-scripts/peaksea'
Plug 'vim-scripts/blackboard.vim'

" documents
Plug 'pright/vimcdoc'
Plug 'vim-scripts/stlrefvim'

" general utils
"Plug 'vim-scripts/Vimball'
""Plug 'vim-airline/vim-airline-themes'
"Plug 'vim-scripts/genutils' | Plug 'vim-scripts/lookupfile'
"Plug 'vim-scripts/Command-T'
"Plug 'vim-scripts/L9' | Plug 'vim-scripts/FuzzyFinder'
"Plug 'vim-scripts/Tabular'
Plug 'Lokaltog/vim-powerline', { 'branch': 'develop' }
Plug 'vim-scripts/grep.vim'
Plug 'mileszs/ack.vim'
Plug 'vim-scripts/YankRing.vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/visSum.vim'
Plug 'junegunn/vim-easy-align'
Plug 'terryma/vim-multiple-cursors'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'
Plug 'benmills/vimux'
Plug 'dhruvasagar/vim-table-mode'
" Plug 'edkolev/promptline.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'dkprice/vim-easygrep'

" programming
" Plug 'vim-scripts/TaskList.vim'
" Plug 'pright/c.vim'
" Plug 'pright/CCTree'
" Plug 'pright/stl-tags'
" Plug 'pright/glibc-tags'
" Plug 'pright/mytags'
"Plug 'drmingdrmer/xptemplate'
"Plug 'vim-scripts/UltiSnips'
"Plug 'vim-scripts/clang-complete'
" Plug 'MarcWeber/vim-addon-mw-utils' | Plug 'tomtom/tlib_vim' | Plug 'garbas/vim-snipmate'
"Plug 'vim-scripts/bufexplorer.zip'
"Plug 'vim-scripts/taglist.vim'
"Plug 'pright/winmanager--Fox'
" Plug 'scrooloose/syntastic'
"Plug 'ludovicchabant/vim-gutentags'
"Plug 'w0rp/ale'
Plug 'vim-scripts/a.vim', { 'for': ['c', 'cpp'] }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'mbbill/echofunc'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'davidhalter/jedi-vim', { 'do': 'git submodule update --init', 'for': 'python' }
Plug 'vim-scripts/pep8'
Plug 'pright/vim-snippets'
Plug 'tpope/vim-fugitive'
if has('nvim') || has('patch-8.0.902')
    Plug 'mhinz/vim-signify'
else
    Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
endif
Plug 'vim-scripts/minibufexpl.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'mattn/emmet-vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'Yggdroot/indentLine'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'lfv89/vim-interestingwords'
Plug 'itchyny/vim-cursorword'

" completion
" Plug 'Valloric/YouCompleteMe'
" Plug 'vim-scripts/code_complete'
" Plug 'vim-scripts/OmniCppComplete', { 'for': ['c', 'cpp'] }
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc.nvim clangd completion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:script_cwd = expand('<sfile>:p:h')
let s:source_list = [
      \ 'viml',
      \ 'config',
      \]

for s:item in s:source_list
  let s:path = split(globpath(s:script_cwd . '/' . s:item, '*.vim'), '\n')
  for s:cfg in s:path
    if filereadable(s:cfg)
      execute 'source ' . s:cfg
    endif
  endfor
endfor

unlet s:script_cwd
unlet s:source_list

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
nnoremap <silent> <leader>n :cn<CR>
nnoremap <silent> <leader>p :cp<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimcdoc
" Set the language in help files
set helplang=cn

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NerdTree
let NERDTreeWinPos="left"
nnoremap <silent> <F3> :NERDTreeToggle<CR>


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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ctags
"set tags+=~/.vim/bundle/stl-tags/tags
"set tags+=~/.vim/bundle/glibc-tags/tags
"set tags+=~/.vim/bundle/mytags/hi3716c_sdk50_framework_base.tags
if filereadable("tags")
    set tags+=tags
endif

nnoremap <silent> <leader>u :!update_tags<CR>:cs reset<CR><CR>

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
if !executable('ag')
    let Grep_Default_Filelist = '*.c *.cpp *.h'
    let Grep_Skip_Files = '*.bak *~'
    let Grep_Default_Options = '-i'
    nnoremap <silent> <F5> :Rgrep<CR>
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ack.vim
if executable('ag')
    "let g:ackprg = 'ag --vimgrep'
    let g:ackprg = 'ag -f -i --nogroup --nocolor --column'
    let g:ackhighlight = 1
    nnoremap <F5> :Ack!<Space><C-R><C-W>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OmniCppComplete
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_NamespaceSearch = 1
let OmniCpp_DisplayMode = 1
let OmniCpp_ShowScopeInAbbr = 0
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
set foldmethod=syntax
set foldlevel=100

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" echofunc
let g:EchoFuncKeyPrev="<C-p>"
let g:EchoFuncKeyNext="<C-n>"

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
"let g:DoxygenToolkit_briefTag_pre="@Synopsis "
"let g:DoxygenToolkit_paramTag_pre="@Param "
"let g:DoxygenToolkit_returnTag="@Returns "
"let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
"let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="MagicYang"
"let g:DoxygenToolkit_licenseTag="My own license"   <-- !!! Does not end with "\<enter>"
let g:doxygenToolkit_briefTag_funcName="yes"
nnoremap <F9>a :DoxAuthor
nnoremap <F9>f :Dox
nnoremap <F9>b :DoxBlock
nnoremap <F9>c O/** */<Left><Left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FuzzyFinder
"let g:fuf_modesDisable = []
"let g:fuf_mrufile_maxItem = 400
"let g:fuf_mrucmd_maxItem = 400
"nnoremap <silent> <leader>f :FufFile<CR>
"nnoremap <silent> <leader>F :FufCoverageFile<CR>
"nnoremap <silent> <leader>t :FufBufferTag<CR>
"nnoremap <silent> <leader>T :FufTag<CR>
"nnoremap <silent> <leader>r :FufMruFileInCwd<CR>
"nnoremap <silent> <leader>R :FufMruFile<CR>
"nnoremap <silent> <leader>u :FufBuffer<CR>
"nnoremap <silent> <leader>a :FufBookmarkFileAdd<CR>
"nnoremap <silent> <leader>b :FufBookmarkFile<CR>
"nnoremap <silent> <leader>d :FufDir<CR>
"nnoremap <silent> <leader>] :FufTagWithCursorWord!<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" YankRing
let g:yankring_history_file = '.yankring_history'
nnoremap <silent> <F6> :YRShow<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CCTree
"let g:CCTreeCscopeDb = "cscope.out"
" using my own command to generate cctree.out because cctree cannot parse the
" one which ccglue generates.
nnoremap <silent> <F10> :MyCCTreeLoadXRefDB<CR>
nnoremap <silent> <F10>r :MyCCTreeLoadDB<CR>

command! -nargs=0 MyCCTreeLoadXRefDB call MyCCTreeLoadDBFunc(0)
command! -nargs=0 MyCCTreeLoadDB call MyCCTreeLoadDBFunc(1)

function! MyCCTreeLoadDBFunc(rebuild)
    if a:rebuild==1 || !filereadable("cctree.out")
        :CCTreeLoadDB cscope.out
        :CCTreeSaveXRefDB cctree.out
    else
        :CCTreeLoadXRefDBFromDisk cctree.out
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tagbar
let g:tagbar_sort = 0
let g:tagbar_left = 0
nnoremap <silent> <F4> :TagbarToggle<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " TaskList
" let g:tlWindowPosition = 1
" map <leader>v <Plug>TaskList

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" pep8
let g:pep8_map='<leader>8'

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
let g:airline#extensions#whitespace#enabled = 0
let g:airline_theme = 'dark'
let g:airline_powerline_fonts = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fzf.vim
" Setting ag as the default source for fzf
if executable('ag')
    let $FZF_DEFAULT_COMMAND = 'ag -g ""'
endif
" This is the default extra key bindings
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

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

nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>t :BTags<CR>
nnoremap <silent> <leader>T :Tags<CR>
nnoremap <silent> <leader>r :History<CR>
nnoremap <silent> <leader>c :History:<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>g :Ag<CR>
nnoremap <silent> <leader>G :Ag!<CR>
nnoremap <silent> <leader>m :Marks<CR>
nnoremap <silent> <leader>w :Windows<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimux
let g:VimuxHeight = "30"
let g:VimuxOrientation = "h"

function! VimuxSlime()
    call VimuxSendText(@v)
    call VimuxSendKeys("Enter")
endfunction

" If text is selected, save it in the v buffer and send that buffer it to tmux
vmap <Leader>vs "vy :call VimuxSlime()<CR>

" Select current paragraph and send it to tmux
nmap <Leader>vs vip<Leader>vs<CR>

" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vm :VimuxPromptCommand("make ")<CR>

" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>

" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>

" Close vim tmux runner opened by VimuxRunCommand
map <Leader>vq :VimuxCloseRunner<CR>

" Interrupt any command running in the runner pane
map <Leader>vx :VimuxInterruptRunner<CR>

" Zoom the runner pane (use <bind-key> z to restore runner pane)
map <Leader>vz :call VimuxZoomRunner()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-table-mode
"let g:table_mode_corner='|'
let g:table_mode_corner_corner = '+'
"let g:table_mode_header_fillchar='='

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdcommenter
let g:NERDCustomDelimiters = {
            \ 'asm': { 'left': '/*', 'right': '*/' }
            \ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" promptline.vim
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
let g:tmuxline_preset = 'tmux'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-gutentags
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
"""""新文件标题
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()"
""定义函数SetTitle，自动插入文件头
func SetTitle()
	"如果文件类型为.sh文件
	if &filetype == 'sh'
		call setline(1,"\#!/bin/bash")
		call append(line("."), "")
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
		call append(line("."), "	> File Name: ".expand("%"))
		call append(line(".")+1, "	> Author: MagicYang")
		call append(line(".")+2, "	> Mail: ")
		call append(line(".")+3, "	> Created Time: ".strftime("%c"))
		call append(line(".")+4, " ************************************************************************/")
		call append(line(".")+5, "")
	endif
	if expand("%:e") == 'cpp'
		call append(line(".")+6, "#include<iostream>")
		call append(line(".")+7, "using namespace std;")
		call append(line(".")+8, "")
	endif
	if &filetype == 'c'
		call append(line(".")+6, "#include<stdio.h>")
		call append(line(".")+7, "")
	endif
	if expand("%:e") == 'h'
		call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_H")
		call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
		call append(line(".")+8, "#endif")
	endif
	if &filetype == 'java'
		call append(line(".")+6,"public class ".expand("%:r"))
		call append(line(".")+7,"")
	endif
	"新建文件后，自动定位到文件末尾
endfunc
autocmd BufNewFile * normal G

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" eggcache vim
"nnoremap ; :
:command W w
:command WQ wq
:command Wq wq
:command Q q
:command Qa qa
:command QA qa
:command QW qa

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable("cscope/load.vim")
    source ./cscope/load.vim
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""实用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" 设置当文件被改动时自动载入
""set autoread
""" quickfix模式
""autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>
"""代码补全
""set completeopt=preview,menu
"""允许插件
""filetype plugin on
"""共享剪贴板
""set clipboard+=unnamed
"""从不备份
""set nobackup
"""make 运行
"":set makeprg=g++\ -Wall\ \ %
"""自动保存
""set autowrite
""set ruler                   " 打开状态栏标尺
""set cursorline              " 突出显示当前行
""set magic                   " 设置魔术
""set guioptions-=T           " 隐藏工具栏
""set guioptions-=m           " 隐藏菜单栏
"""set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)\
""" 设置在状态行显示的信息
""set foldcolumn=0
""set foldmethod=indent
""set foldlevel=3
""set foldenable              " 开始折叠
""" 不要使用vi的键盘模式，而是vim自己的
""set nocompatible
""" 语法高亮
""set syntax=on
""" 去掉输入错误的提示声音
""set noeb
""" 在处理未保存或只读文件的时候，弹出确认
""set confirm
""" 自动缩进
""set autoindent
""set cindent
""" Tab键的宽度
""set tabstop=4
""" 统一缩进为4
""set softtabstop=4
""set shiftwidth=4
""" 不要用空格代替制表符
""set noexpandtab
""" 在行和段开始处使用制表符
""set smarttab
""" 显示行号
""set number
""" 历史记录数
""set history=1000
"""禁止生成临时文件
""set nobackup
""set noswapfile
"""搜索忽略大小写
""set ignorecase
"""搜索逐字符高亮
""set hlsearch
""set incsearch
"""行内替换
""set gdefault
"""编码设置
""set enc=utf-8
""set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
"""语言设置
""set langmenu=zh_CN.UTF-8
""set helplang=cn
""" 我的状态行显示的内容（包括文件类型和解码）
"""set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
"""set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
""" 总是显示状态行
""set laststatus=2
""" 命令行（在状态行下）的高度，默认为1，这里是2
""set cmdheight=2
""" 侦测文件类型
""filetype on
""" 载入文件类型插件
""filetype plugin on
""" 为特定文件类型载入相关缩进文件
""filetype indent on
""" 保存全局变量
""set viminfo+=!
""" 带有如下符号的单词不要被换行分割
""set iskeyword+=_,$,@,%,#,-
""" 字符间插入的像素行数目
""set linespace=0
""" 增强模式中的命令行自动完成操作
""set wildmenu
""" 使回格键（backspace）正常处理indent, eol, start等
""set backspace=2
""" 允许backspace和光标键跨越行边界
""set whichwrap+=<,>,h,l
""" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
""set mouse=a
""set selection=exclusive
""set selectmode=mouse,key
""" 通过使用: commands命令，告诉我们文件的哪一行被改变过
""set report=0
""" 在被分割的窗口间显示空白，便于阅读
""set fillchars=vert:\ ,stl:\ ,stlnc:\
""" 高亮显示匹配的括号
""set showmatch
""" 匹配括号高亮的时间（单位是十分之一秒）
""set matchtime=1
""" 光标移动到buffer的顶部和底部时保持3行距离
""set scrolloff=3
""" 为C程序提供自动缩进
""set smartindent
""" 高亮显示普通txt文件（需要txt.vim脚本）
""au BufRead,BufNewFile *  setfiletype txt
"""自动补全
"":inoremap ( ()<ESC>i
"":inoremap ) <c-r>=ClosePair(')')<CR>
""":inoremap { {<CR>}<ESC>O
""":inoremap } <c-r>=ClosePair('}')<CR>
"":inoremap [ []<ESC>i
"":inoremap ] <c-r>=ClosePair(']')<CR>
"":inoremap " ""<ESC>i
"":inoremap ' ''<ESC>i
""function! ClosePair(char)
""        if getline('.')[col('.') - 1] == a:char
""                return "\<Right>"
""        else
""                return a:char
""        endif
""endfunction
""filetype plugin indent on
"""打开文件类型检测, 加了这句才可以用智能补全
""set completeopt=longest,menu
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

