"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Global settings
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Always show the statusline
set laststatus=2

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
    set nobackup		" do not keep a backup file, use versions instead
else
    set backup		" keep a backup file
endif

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" relative line number
set rnu

" tab width
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
set smarttab

" encoding
let &termencoding=&encoding
set fileencoding=cp936
"set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencodings=cp936,ucs-bom,utf-8

set updatetime=100

set completeopt=longest,menu
set nocp

set ignorecase smartcase

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

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
" Vundle
" git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My bundles
" color scheme
Bundle 'peaksea'

" documents
Bundle 'pright/vimcdoc'
Bundle 'stlrefvim'

" general utils
Bundle 'Vimball'
Bundle 'grep.vim'
Bundle 'YankRing.vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/vim-powerline'
" genutils(required by lookupfile)
"Bundle 'genutils'
"Bundle 'lookupfile'
"Bundle 'Command-T'
" L9(required by FuzzyFinder)
Bundle 'L9' 
Bundle 'FuzzyFinder'
Bundle 'visSum.vim'

" programming
Bundle 'a.vim'
Bundle 'pright/c.vim'
Bundle 'echofunc.vim'
Bundle 'DoxygenToolkit.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'pright/CCTree'
Bundle 'pright/stl-tags'
Bundle 'pright/glibc-tags'
Bundle 'pright/mytags'
Bundle 'OmniCppComplete'
"Bundle 'clang-complete'
"Bundle 'Valloric/YouCompleteMe'
"Bundle 'code_complete'
Bundle 'pright/snipmate.vim'
"Bundle 'UltiSnips'
Bundle 'tpope/vim-fugitive'
"Bundle 'minibufexpl.vim'
"Bundle "bufexplorer.zip"
Bundle 'scrooloose/nerdtree'
"Bundle 'taglist.vim'
Bundle 'Tagbar'
"Bundle 'pright/winmanager--Fox'

filetype plugin indent on     " required!
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color
if $TERM!="linux"
    if has("gui_running") 
        set t_Co=256 
        "set term=xterm-256color
        set term=xterm
        set guifont=Monaco
    endif
    colors peaksea 
    set background=dark 
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" QuickFix
nnoremap <silent> <F7> :cp<CR>
nnoremap <silent> <F8> :cn<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimcdoc
" Set the language in help files
set helplang=cn

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NerdTree
nnoremap <silent> <F3> :NERDTreeToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" taglist
"let Tlist_Show_One_File=1
"let Tlist_Exit_OnlyWindow=1
"let Tlist_Use_Right_Window=1
"nnoremap <silent> <F4> :TlistToggle<CR>

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
:set cscopequickfix=s-,c-,d-,i-,t-,e-
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ctags
set tags+=~/.vim/bundle/stl-tags/tags
set tags+=~/.vim/bundle/glibc-tags/tags
"set tags+=~/.vim/bundle/mytags/hi3716c_sdk50_framework_base.tags
if filereadable("tags")
    set tags+=tags
endif

nnoremap <silent> <F11> :!update_tags &<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" minibufexpl
"let g:miniBufExplMapCTabSwitchBufs=1
"let g:miniBufExplMapWindowNavVim=1
"let g:miniBufExplMapWindowNavArrows=1
"let g:miniBufExplModSelTarget=1
"let g:miniBufExplForceSyntaxEnable = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" a.vim
nnoremap <silent> <F12> :A<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" grep.vim
nnoremap <silent> <F5> :Rgrep<CR>
let Grep_Default_Filelist = '*.c *.cpp *.h'
let Grep_Skip_Files = '*.bak *~'
let Grep_Default_ptions = '-i'

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
let g:DoxygenToolkit_authorName="Jun Xie" 
"let g:DoxygenToolkit_licenseTag="My own license"   <-- !!! Does not end with "\<enter>"
let g:doxygenToolkit_briefTag_funcName="yes"
nnoremap <F2>a :DoxAuthor
nnoremap <F2>f :Dox
nnoremap <F2>b :DoxBlock
nnoremap <F2>c O/** */<Left><Left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FuzzyFinder
let g:fuf_modesDisable = []
let g:fuf_mrufile_maxItem = 400
let g:fuf_mrucmd_maxItem = 400
nnoremap <silent> <leader>f :FufFile<CR>
nnoremap <silent> <leader>F :FufCoverageFile<CR>
nnoremap <silent> <leader>t :FufBufferTag<CR>
nnoremap <silent> <leader>T :FufTag<CR>
nnoremap <silent> <leader>r :FufMruFileInCwd<CR>
nnoremap <silent> <leader>R :FufMruFile<CR>
nnoremap <silent> <leader>u :FufBuffer<CR>
nnoremap <silent> <leader>a :FufBookmarkFileAdd<CR>
nnoremap <silent> <leader>b :FufBookmarkFile<CR>
nnoremap <silent> <leader>d :FufDir<CR>
nnoremap <silent> <leader>] :FufTagWithCursorWord!<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YankRing
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
" Tagbar
let g:tagbar_sort = 0
nnoremap <silent> <F4> :TagbarToggle<CR>
