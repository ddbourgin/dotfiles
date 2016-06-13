python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Bundle 'gmarik/vundle'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-surround'
"Plugin 'airblade/vim-gitgutter'      " for displaying git diff in gutter
Plugin 'scrooloose/nerdcommenter'     " for <leader>ci to toggle comments
Plugin 'terryma/vim-multiple-cursors' " for sublime-style cmd+d selection
"Plugin 'godlygeek/tabular'           " for aliging text to characters
Plugin 'tpope/vim-fugitive'           " for :Gstatus, :Gcommit, etc.
"Plugin 'scrooloose/syntastic'        " for code linting
"Plugin 'nathanaelkane/vim-indent-guides'

" Some settings to enable solarized theme:
set term=builtin_beos-ansi
set number        " Show line numbers
syntax enable     " Use syntax highlighting
set background=dark
let g:solarized_termcolors=16
colorscheme solarized

" Powerline options
set guifont=Inconsolata\ for\ Powerline:h15
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" Always show current position
set ruler

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Show matching brackets when text indicator is over them
set showmatch 

" How many tenths of a second to blink when matching brackets
set mat=2

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

""""""""""""""""""""""""""""""
" => Status line
" """"""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
            return 'PASTE MODE  '
    endif
    return ''
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
    nmap <D-j> <M-j>
    nmap <D-k> <M-k>
    vmap <D-j> <M-j>
    vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS(#)

" No annoying sound on errors
"set noerrorbells
"set novisualbell
"set t_vb=
"set tm=500
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext 

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files 
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Remember info about open buffers on close
set viminfo^=%

" Use system clipboard for all copy-paste actions
set clipboard=unnamed

" make 'tab' insert indents instead of tabs at the beginning of a line
set smarttab

" size of an 'indent'
set shiftwidth=4

" size of a hard tabstop
set tabstop=8

" a combination of spaces and tabs are used to simulate tab stops at a width
" other than the (hard) tabstop
set softtabstop=0

" always uses spaces instead of tab characters
set expandtab

" Allow using the mouse for visual selection
" set mouse=a
"
" Syntastic Settings
let g:syntastic_python_checkers = ['pylint']

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_python_pylint_quiet_messages = {"regex": ['\[invalid\-name\]', '\[missing\-docstring\]']}

" Indent-Guides Settings
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
