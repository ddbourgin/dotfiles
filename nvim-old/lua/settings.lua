local o = vim.o

vim.g.mapleader = " "

-- rhubarb settings
vim.g.github_enterprise_urls = { "https://git.corp.adobe.com" }

o.syntax = 'ON'
o.splitright = true
o.splitbelow = true
o.showtabline = 2
-- o.background = "dark"

-- disable swap files
o.swapfile = false

-- turn off annoying errorbells
o.errorbells = false

-- Make line numbers default
vim.wo.number = true

-- Disable mouse mode
o.mouse = ''

-- Enable break indent
o.breakindent = true

-- Remember info about open buffers on close
--   '10  :  marks will be remembered for up to 10 previously edited files
--   "100 :  will save up to 100 lines for each register
--   :20  :  up to 20 lines of command-line history will be remembered
--   %    :  saves and restores the buffer list
--   n... :  where to save the viminfo files
o.viminfo = "'10,\"100,:20,%,"

-- Save undo history
o.undofile = true
-- o.undodir = os.getenv("HOME") .. "/.vim-local/undo-dir/"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
o.clipboard = 'unnamedplus'

-- Make 'tab' insert indents instead of tabs at the beginning of a line
o.smarttab = true

-- Size of an 'indent'
o.shiftwidth = 4

-- Size of a hard tabstop
o.tabstop = 8

-- a combination of spaces and tabs are used to simulate tab stops at a width
-- other than the(hard) tabstop
o.softtabstop = 0

-- Always use spaces instead of tabs
o.expandtab = true

-- Configure backspace so it acts as it should act
o.backspace = "eol,start,indent"
o.whichwrap = o.whichwrap .. "<,>,h,l"

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- Set highlight on search
o.hlsearch = true

-- Makes search act like search in modern browsers
o.incsearch = true

-- Show matching brackets when text indicator is over them
o.showmatch = true

-- How many tenths of a second to blink when matching brackets
o.mat = 2

-- Set utf8 as standard encoding and en_US as the standard language
o.encoding = 'utf8'

-- Set unix as the standard file type
o.ffs = "unix,dos,mac"

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
o.timeout = true
o.updatetime = 250
o.timeoutlen = 300

-- Set completeopt to have a better completion experience
o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
o.termguicolors = false

-- Keep indentation from previous line
-- o.autoindent = true

-- Automatically inserts indentation in some cases
-- o.smartindent = true

-- Like smartindent, but stricter and more customisable
-- o.cindent = true
