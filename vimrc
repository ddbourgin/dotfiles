set nocompatible              " be iMproved, required
filetype off                  " required

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vundle Settings
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - removal of unused plugins; append `!` to auto-approve removal
" see `:h vundle` for more details or wiki for FAQ

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim/

" include fzf on the runtime path (must be installed locally first!)
set rtp+=/usr/local/opt/fzf

call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" to install the plugins via vundle, type :source % then :PluginInstall
Bundle 'gmarik/vundle'
Plugin 'lervag/vimtex'                    " for working with latex
Plugin 'chiel92/vim-autoformat'           " for autoformatting code
Plugin 'tpope/vim-surround'               " for quickly changing tags/delimeters/quotes
Plugin 'yggdroot/indentline'              " for indent guides
Plugin 'scrooloose/nerdcommenter'         " for <leader>ci to toggle comments
Plugin 'terryma/vim-multiple-cursors'     " for sublime-style cmd+d selection via ctrl+n
Plugin 'altercation/vim-colors-solarized' " for pretty colors
Plugin 'SirVer/ultisnips'                 " for snippets
Plugin 'honza/vim-snippets'               " extra snippets for ultisnippets
Plugin 'godlygeek/tabular'                " for aligning text to characters
Plugin 'scrooloose/syntastic'             " for code linting
Plugin 'Valloric/YouCompleteMe'           " for code completion
Plugin 'easymotion/vim-easymotion'        " for quick navigation in file via F<search character>
Plugin 'itchyny/lightline.vim'            " light-weight powerline alternative
Plugin 'bling/vim-bufferline'             " show buffers in tabline
Plugin 'junegunn/fzf.vim'                 " use fzf within vim using the :Files command
Plugin 'pangloss/vim-javascript'          " improved javascript highlighting and indentation
Plugin 'ambv/black'                       " for python code formatting
Plugin 'supercollider/scvim'              " supercollider plugin
Plugin 'tidalcycles/vim-tidal'            " tidal plugin
Plugin 'derekwyatt/vim-scala'             " scala syntax highlighting/formatting

filetype plugin on   " re-enable filetype

" Run Black on save
" may or may not require running `pip install black`
autocmd BufWritePre *.py execute ':Black'

""""""""""""""""""""""""
"  netrw File Browser  "
""""""""""""""""""""""""
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:NetrwIsOpen=0

function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction

map ; :call ToggleNetrw()<CR>


""""""""""""""""""""""
"  FZF.vim settings  "
""""""""""""""""""""""
" open fuzzy file browser with ;
" map ; :Files<CR>

" display browser at the top of the screen
let g:fzf_layout = { 'up': '~40%' }

""""""""""""""""""""
"  Basic Settings  "
""""""""""""""""""""
set number                            " For displaying line numbers
"set number relativenumber            " For displaying relative line numbers
syntax enable                         " Use syntax highlighting
set noswapfile                        " Disable swap files

" Set to auto read when a file is changed from the outside
set autoread

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Always show current position
set ruler

" Create a vim-local directory if one doesn't exist for storing buffer info,
" undo history, etc.
if !isdirectory($HOME."/.vim-local")
    call mkdir($HOME."/.vim-local", "", 0700)
endif

if !isdirectory($HOME."/.vim-local/undo-dir")
    call mkdir($HOME."/.vim-local/undo-dir", "", 0700)
endif

" Remember info about open buffers on close
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,

if !has('nvim')
    set viminfo+=n~/.vim-local/viminfo
endif

"Enable persisted undo history
set undofile
set undodir=~/.vim-local/undo-dir/

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
"set mouse=a

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

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

""""""""""""""""""""""""
"  Solarized Settings  "
""""""""""""""""""""""""
" set background=dark
" let g:solarized_termcolors=16
" colorscheme solarized

"""""""""""""""""""""""""
"  SpellCheck Settings  "
"""""""""""""""""""""""""
" Add a new word to the dictionary by highlighting it and hitting `zg`
set spellfile=$HOME/.vim-spell-en.utf-8.add
set spell spelllang=en_us

" set misspelled highlight style
hi clear SpellBad
hi SpellBad cterm=underline ctermfg=red

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" List of filetypes to apply spellcheck
autocmd FileType html setlocal spell
autocmd FileType markdown setlocal spell
autocmd FileType tex setlocal spell
autocmd FileType text setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd FileType vimwiki setlocal spell

" turn off spellcheck for these filetypes
autocmd FileType python setlocal nospell
autocmd FileType java setlocal nospell
autocmd FileType javascript setlocal nospell
autocmd FileType json setlocal nospell
autocmd FileType r setlocal nospell
autocmd FileType matlab setlocal nospell
autocmd FileType yaml setlocal nospell
autocmd FileType sh setlocal nospell
autocmd FileType bash setlocal nospell
autocmd FileType vim setlocal nospell
autocmd FileType supercollider setlocal nospell

"""""""""""""""""""""""""
"  EasyMotion Settings  "
"""""""""""""""""""""""""
" turn on case-insensitive matching
let g:EasyMotion_smartcase = 1

" Search for single character string in visible buffer with f<characters>
map <Leader> <Plug>(easymotion-prefix)
nmap f <Plug>(easymotion-s)

""""""""""""""""""""""""
"  Lightline Settings  "
""""""""""""""""""""""""
set noshowmode

" color schemes:
" wombat, solarized, powerline, jellybeans, Tomorrow, Tomorrow_Night,
" Tomorrow_Night_Blue, Tomorrow_Night_Eighties, PaperColor, seoul256,
" landscape, one, darcula, molokai, materia, material, OldHope, nord, 16color,
" deus
let g:lightline = {
            \ 'colorscheme': 'darcula',
            \ 'tabline': {
            \   'left': [ ['bufferline'] ],
            \   'right': [ [] ]
            \ },
            \ 'component_expand': {
            \   'bufferline': 'LightlineBufferline',
            \ },
            \ 'component_type': {
            \   'bufferline': 'tabsel',
            \ },
            \ }

" custom bufferline function to display in tabline
function! LightlineBufferline()
    call bufferline#refresh_status()
    return [ g:bufferline_status_info.before, g:bufferline_status_info.current, g:bufferline_status_info.after]
endfunction

set showtabline=2  " Always show tabline
set guioptions-=e  " Don't use GUI tabline

"""""""""""""""""""""""""
"  BufferLine Settings  "
"""""""""""""""""""""""""
" don't duplicate buffer list in the command bar
let g:bufferline_echo = 0

" don't draw dividers between buffers in the statusline
let g:bufferline_active_buffer_left = ''
let g:bufferline_active_buffer_right = ''

"""""""""""""""""""""""""""
"  Vim-Surround Settings  "
"""""""""""""""""""""""""""
let g:surround_98 = "\\textbf{\r}"  "b
let g:surround_101 = "\\emph{\r}"   "e
let g:surround_73 = "\n\\begin{itemize}\n\t \\item \r \n\\end{itemize}\n"       "I
let g:surround_69 = "\n\\begin{enumerate}\n\t \\item \r \n\\end{enumerate}\n"   "E

"""""""""""""""""""""""""
"  IndentLine Settings  "
"""""""""""""""""""""""""
" Use Ctrl-i to toggle indent guides
nmap <C-i> :IndentLinesToggle<cr>

""""""""""""""""""""""""""""""""
"  UltiSnips Snippet Settings  "
""""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsListSnippets='<c-s>'
let g:ultisnips_python_style='numpy' " use numpy-style docstrings

"""""""""""""""""""""""""""""""
"  Syntastic Linter Settings  "
"""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" move through linter errors with Ctrl-d (move down) and Ctrl-u (move up)
nmap <C-d> :lnext<cr>
nmap <C-u> :lprevious<cr>

" run linter with <leader>e, hide the error list
" nmap <C-e> :SyntasticCheck<cr>:lclose<cr>

let b:syntastic_mode = 'active'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" let g:syntastic_enable_signs = 1
" let g:syntastic_auto_loc_list = 2

let g:syntastic_error_symbol = '🐞' "'!!'
let g:syntastic_style_error_symbol = '🐞'
let g:syntastic_warning_symbol = '⁂'
let g:syntastic_style_warning_symbol = '⁂'

let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_java_checkers = ['astyle']
let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_markdown_checkers = ['remark']
let g:syntastic_python_pylint_quiet_messages = {"regex": ['\[invalid\-name\]', '\[missing\-docstring\]', '\[import-error\]','\[superfluous-parens\]', '\[wrong-spelling-in-comment\]', '\[wrong-spelling-in-docstring\]']}

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

""""""""""""""""""""""""""
"  NERDComment Settings  "
""""""""""""""""""""""""""
" toggle comments with Ctrl-\
noremap  :call NERDComment(0,"toggle")<C-m>

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Align line-wise comment delimiters flush left
let g:NERDDefaultAlign = 'left'

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

"""""""""""""""""""""
"  VimTex Settings  "
"""""""""""""""""""""

" autocmd FileType tex setlocal indentexpr=
au BufRead,BufNewFile *.tex setlocal textwidth=80
au BufRead,BufNewFile *.md setlocal textwidth=80

" Compile and view LaTeX documents with <leader>b
" nmap <leader>b :w!<cr><plug>(vimtex-compile)<plug>(vimtex-view)
" nmap <leader>b :w!<cr>:VimtexCompile<cr>:VimtexView<cr>

autocmd FileType tex nmap <buffer> <leader>b :w!<cr>:VimtexCompile<cr>:VimtexView<cr>

let g:vimtex_view_general_viewer = '/applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
let g:vimtex_view_general_options_latexmk = '-r 1'
let g:vimtex_latexmk_continuous = 0
let g:vimtex_indent_enabled = 1
let g:vimtex_fold_enabled = 0
let g:tex_flavor='latex'
let g:vimtex_format_enabled = 1

" ignore the `can't use callbacks without +clientserver` error
let g:vimtex_disable_version_warning = 2

" Turn off rendering of LaTeX backslash commands to unicode characters
" a = conceal accents/ligatures
" d = conceal delimiters
" g = conceal Greek
" m = conceal math symbols
" s = conceal superscripts/subscripts
let g:tex_conceal=""
set conceallevel=1

" suppress automatic styling of italic and bold text in latex
hi clear texItalStyle
hi clear texBoldStyle

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Tidal-Vim Settings                             "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:get_visual_selection()
  " http://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

au BufEnter,BufWinEnter,BufNewFile,BufRead *.tidal set filetype=tidal
au Filetype tidal packadd tidal

" edit the default tmux socket numbers when running tidalvim
let g:tidal_default_config = {"socket_name": "default", "target_pane": "tidal:1.3"}

" disable default mappings and redefine below
let g:tidal_no_mappings = 1

" mute a given track with <leader>d <track number> (mneumonic: d[elete])
let n = 1
while n <= 99
    execute "autocmd FileType tidal nmap <leader>d" . n . " :TidalSilence " . n . "<cr>"
    let n += 1
endwhile

" solo a given track with <leader>s <track number> (mneumonic: s[olo])
let n = 1
while n <= 99
    execute "autocmd FileType tidal nmap <leader>s" . n . " :TidalSend1 solo " . n . "<cr>"
    let n += 1
endwhile

" unsolo a given track with <leader>a <track number> 
let n = 1
while n <= 99
    execute "autocmd FileType tidal nmap <leader>a" . n . " :TidalSend1 unsolo " . n . "<cr>"
    let n += 1
endwhile

autocmd FileType tidal nmap <buffer> <localleader>m  <Plug>TidalLineSend

" send line with <leader>c
autocmd FileType tidal nmap <buffer> <localleader>c  <Plug>TidalLineSend

" send code block with <leader>b
autocmd FileType tidal xmap <buffer> <leader>b  <Plug>TidalRegionSend

" send code block with <leader>b
autocmd FileType tidal nmap <buffer> <leader>b <Plug>TidalParagraphSend

" stop sound with <leader>k
autocmd FileType tidal nnoremap <buffer> <leader>k :TidalHush<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                        Supercollider/scvim Settings                        "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

au BufEnter,BufWinEnter,BufNewFile,BufRead *.sc,*.scd set filetype=supercollider
au Filetype supercollider packadd scvim

" enable highlighting of evaluated code
let g:scFlash = 1

" command to open a terminal window
let g:sclangTerm="open -a iTerm ."

" print the args for the first method on the current line with F
autocmd FileType supercollider nmap <buffer> F :call SCfindArgs()<cr>

" print the args for the visually selected text with F
autocmd FileType supercollider vmap <buffer> F :call SCfindArgsFromSelection()<cr>

" execute a block of code scvim with <leader>b

" autocmd FileType supercollider vmap <buffer> <leader>b J0<F6>u
autocmd FileType supercollider nmap <buffer> <leader>b <F5>

" execute a line of code scvim with <leader>c
autocmd FileType supercollider nmap <buffer> <leader>c <F6>

" hard stop audio in scvim with <leader>k
autocmd FileType supercollider nmap <buffer> <leader>k <F12>

""""""""""""""""""""""
"  VimWiki Settings  "
""""""""""""""""""""""
" Compile vimwiki pages using <leader>h
nmap <leader>h :w!<cr>:VimwikiAll2HTML<cr>

" Open the vimwiki index page using <leader>vw
nmap <leader>vw :VimwikiIndex<cr>

let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.nested_syntaxes = {'python': 'python', 'shell': 'sh', 'js': 'js'}
let g:vimwiki_list = [wiki]

""""""""""""""""""""""""""""""""""""""""
"  Vim-Format Autoformatting Settings  "
""""""""""""""""""""""""""""""""""""""""
" autoformat code block via ctrl-f
noremap <C-f> :Autoformat<cr>

" All of your Plugins must be added before the following line
call vundle#end()     " required

" To ignore plugin indent changes, uncomment the `filetype indent on` line
filetype plugin on    " required
filetype indent on    " required

""""""""""""""""""""""""""""""""""""""""
"           YouCompleteMe              "
""""""""""""""""""""""""""""""""""""""""
let g:ycm_use_ultisnips_completer=1 " Default 1, just ensure
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Down>']
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for current language
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string

" map Ctrl-g to go to the 'go to definition/declaration' command
nnoremap <C-g> :YcmCompleter GoToDefinitionElseDeclaration<CR>

" map Ctrl-h to go to the 'get documentation' command
nnoremap <C-h> :YcmCompleter GetDoc<CR>

" let YouCompleteMe work for python with virtualenv support
" py << EOF
" import os
" import sys
" if 'VIRTUAL_ENV' in os.environ:
"     project_base_dir = os.environ['VIRTUAL_ENV']
"     activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"     execfile(activate_this, dict(__file__=activate_this))
" EOF

""""""""""""""
"  Mappings  "
""""""""""""""
" Set leader and localleader
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" type <leader>N to switch to buffer number n
let n = 1
while n <= 99
    execute "nnoremap <leader>" . n . " :" . n . "b\<CR>"
    let n += 1
endwhile

" keep text selected after indenting/unindenting
vnoremap < <gv
vnoremap > >gv

" Replay a series of commands recorded with `qq` by pressing `<leader>q`
" instead of `@q`
noremap <leader>q @q

" Fast saving
nmap <leader>w :w!<cr>

" associate *.wiki files with markdown syntax for highlighting
au BufRead,BufNewFile *.wiki setfiletype md

" Move up and down by larger steps
map <C-k> 5k
map <C-j> 5j

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" toggle paste mode on and off using <leader>paste
map <leader>pp :set paste!<cr>

" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
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

" Delete trailing white space on save
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS(#)

" No annoying sound on errors
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines
map j gj
map k gk

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext<cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<cr>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

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

