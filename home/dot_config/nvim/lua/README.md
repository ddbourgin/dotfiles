# My Guide to LazyVim Packages

To see where LazyVim defines its default keybindings, check `~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/config/keymaps.lua`.

## Important Commands

- `:h <plugin-name>`: Display documentation for the given plugin
- `:LazyHealth`: Runs a health check for each installed LazyVim package, reporting
  any warnings or errors
- `:LazyExtras`: Install the

## Useful Keymaps

### General commands

| **Command**  | **Description**                                  | **Mode** | **Plugin**        |
| ------------ | ------------------------------------------------ | -------- | ----------------- |
| `<leader>l`  | Open the LazyNvim mason status window            | `n`      | LazyVim           |
| `<leader>cd` | Show diagnostics for current line                | `n`      | `nvim-lint`       |
| `]d`, `[d`   | Step through diagnostic messages in current file | `n`      | `nvim-lint`       |
| `]e`, `[e`   | Step through error messages in current file      | `n`      | `nvim-lint`       |
| `]w`, `[w`   | Step through warning messages in current file    | `n`      | `nvim-lint`       |
| `<leader>xX` | Show all diagnostics for the current buffer      | `n`      | `trouble.nvim`    |
| `<leader>cf` | Format code                                      | `n`, `v` | `conform.nvim`    |
| `<leader>uF` | Toggle auto-formatting in the current buffer     | `n`      | `conform.nvim`    |
| `<leader>us` | Toggle spell-checking globablly                  | `n`      | `conform.nvim`    |
| `<leader>uS` | Toggle smooth scrolling                          | `n`      | `conform.nvim`    |
| `<leader>ud` | Toggle diagnostic messages globablly             | `n`      | `conform.nvim`    |
| `<leader>ub` | Toggle dark/light background                     | `n`      | `conform.nvim`    |
| `<C-/>`      | Toggle a terminal in the root dir                | `n`      | LazyVim           |
| `<leader>gf` | Browse git history for current file              | `n`      | ???               |
| `L`, `H`     | Switch to next / previous buffer                 | `n`      | `bufferline.nvim` |

### LSP commands

| **Command**  | **Description**                           | **Mode** | **Plugin**       |
| ------------ | ----------------------------------------- | -------- | ---------------- |
| `<leader>K`  | Look up highlighted character in man page | `n`      | ???              |
| `gd`         | Go to definition                          | `n`      | `nvim-lspconfig` |
| `gK`         | Signature help                            | `n`      | `nvim-lspconfig` |
| `<c-k>`      | Signature help                            | `i`      | `nvim-lspconfig` |
| `K`          | Show documentation in pop-under           | `n`      | `nvim-lspconfig` |
| `]]`, `[[`   | Next/previous reference                   | `n`      | `nvim-lspconfig` |
| `<leader>cR` | Rename file                               | `n`      | `nvim-lspconfig` |
| `<leader>cr` | Rename variable under cursor              | `n`      | `nvim-lspconfig` |
| `<leader>ss` | Jump to function def in buffer            | `n`      | `nvim-lspconfig` |
| `<leader>co` | Organize imports in a python file         | `n`      | `nvim-lspconfig` |

| **Command**  | **Description**                                           | **Mode**      | **Plugin**      |
| ------------ | --------------------------------------------------------- | ------------- | --------------- |
| `<leader>sr` | Search and replace                                        | `n`, `v`      | `grug-far.nvim` |
| `s<text>`    | Incrememntal search for `<text>` in buffer                | `n`           | `flash.nvim`    |
| `S<char>`    | Surround selection with `<char>`                          | `n`, `v`      | `mini.surround` |
| `<C-space>`  | Incremental selection. Retap to expand, `<BS>` to reduce. | `n`, `x`, `o` | `flash.nvim`    |
| `<leader>.`  | Open a scratch buffer                                     | `n`           | ???             |
| `<leader>S`  | Select from scratch buffers                               | `n`           | ???             |
| `<leader>cm` | Open Mason window                                         | `n`           | `mason.nvim`    |

| **Command**       | **Description**                         | **Mode** | **Plugin**    |
| ----------------- | --------------------------------------- | -------- | ------------- |
| `<leader><space>` | Find filenames, starting from root dir  | `n`      | `snacks.nvim` |
| `<leader>ff`      | Find filenames, starting from root dir  | `n`      | `snacks.nvim` |
| `<leader>fF`      | Find filenames, starting from cur dir   | `n`      | `snacks.nvim` |
| `<leader>fg`      | Find filenames among files in git       | `n`      | `snacks.nvim` |
| `<leader>fe`      | Open a file explorer from root dir      | `n`      | `snacks.nvim` |
| `<leader>fE`      | Open a file explorer from cur dir       | `n`      | `snacks.nvim` |
| `<leader>/`       | Grep from the root dir                  | `n`      | `snacks.nvim` |
| `<leader>sg`      | Grep from the root dir                  | `n`      | `snacks.nvim` |
| `<leader>sG`      | Grep from the cur dir                   | `n`      | `snacks.nvim` |
| `<leader>sc`      | Grep within vim commands                | `n`      | `snacks.nvim` |
| `<leader>sB`      | Grep within open buffers                | `n`      | `snacks.nvim` |
| `<leader>sh`      | Grep within help pages                  | `n`      | `snacks.nvim` |
| `<leader>sw`      | Grep for visual selection from root dir | `n`      | `snacks.nvim` |
| `<leader>sW`      | Grep for visual selection from cur dir  | `n`      | `snacks.nvim` |

| **Command**      | **Description**                            | **Mode** | **Plugin**  |
| ---------------- | ------------------------------------------ | -------- | ----------- |
| `<C-n>`, `<C-p>` | Navigate up and down in autocomplete list  | `i`      | `blink.cmp` |
| `<C-y>`          | Accept the current autocomplete suggestion | `i`      | `blink.cmp` |

## Language-specific

### Markdown

| **Command**        | **Description**                | **Mode** | **Plugin**              |
| ------------------ | ------------------------------ | -------- | ----------------------- |
| `:MarkdownPreview` | Render markdown in web browser | `n`      | `markdown-preview.nvim` |

### LaTeX

| **Command** | **Description**                    | **Mode** | **Plugin** |
| ----------- | ---------------------------------- | -------- | ---------- |
| `<leader>b` | Compile and view LaTeX doc in Skim | `n`      | `vimtex`   |

## Plugins

### Coding

1. [`mini.pairs`](https://github.com/nvim-mini/mini.pairs): Automatically inserts
   a matching closing character when you type an opening character like `"`, `[`,
   or `(`.
2. [`ts-comments`](https://github.com/folke/ts-comments.nvim): Improves
   comment syntax, lets Neovim handle multiple types of comments for a single
   language, relaxes rules for uncommenting.
3. [`mini.ai`](https://github.com/nvim-mini/mini.ai): Extends the `a` (`i`
   after cursor) & `i` (`i` before cursor) text commands. Adds the ability
   to select arguments, function calls, text within quotes and brackets, and to
   repeat those selections to select an outer text object.
4. [`lazydev`](https://github.com/folke/lazydev.nvim): Configures LuaLS (the
   Lua language server) to support auto-completion and type checking when
   editing the Neovim configuration files.

### Colorscheme

1. [`tokyonight.nvim`](https://github.com/folke/tokyonight.nvim): The default LazyVim
   colorscheme. Currently uses the `"moon"` variant.
2. [`catppuccin`](https://github.com/catppuccin/nvim): A heavier-duty suite of
   color palettes + plugin highlights with integrations for a wider range of
   Neovim plugins. **Not enabled by default.**
3. [`bufferline.nvim`](https://github.com/akinsho/bufferline.nvim): Responsible
   for fancy-looking tabs for the different open buffers.
4. [`blink.cmp`](https://github.com/saghen/blink.cmp): An auto-completion engine.
5. [`friendly-snippets`](https://github.com/rafamadriz/friendly-snippets): Code
   snippets from various languages that can be used with `blink.cmp`.
6. [`mini-surround`](https://github.com/nvim-mini/mini.surround): Surround a
   highlighted piece of text with quotes/brackets/etc.
7. [`lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim): Display a
   fancy status line with git status, LSP diagnostics, filetype information, etc.

### Editor

1. [`grug-far.nvim`](https://github.com/MagicDuck/grug-far.nvim): A **F**ind
   **A**nd **R**eplace plugin that uses ripgrep. A new find/replace editor
   buffer can be launched via the commands `:GrugFar` (recursive search from
   current working directory) and `:GrugFarWithin` (only search within current
   file).
2. [`flash.nvim`](https://github.com/folke/flash.nvim): Enhances built-in Neovim
   search (the `/` and `?` operators) by showing single-letter labels at the
   end of each match, allowing you to quickly jump to a specific match.
3. [`which-key.nvim`](https://github.com/folke/which-key.nvim): Shows a popup
   with the active keybindings of the command you started typing. To launch,
   simply type `<leader>[<optional characters]` and the popup will appear.
4. [`gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim): Highlights
   text that has changed since the last git commit, lets you interactively
   stage & unstage hunks in a commit. Launch editor via `:GitSigns <command>`
5. [`trouble.nvim`](https://github.com/folke/trouble.nvim): An API that can be
   used to create a pretty list interface for displaying diagnostics,
   references, telescope results, quickfix and location lists.
6. [`todo-comments.nvim`](https://www.lazyvim.org/plugins/editor): Finds and
   lists all of the TODO, HACK, BUG, etc. comments in your project and loads
   them into a browsable list. Use `[t` and `]t` to jump between comments in
   the current file.

### Formatting

1. [`conform.nvim`](https://github.com/stevearc/conform.nvim): A code formatter
   plugin. Allows you to specify which formatters you want to use for each
   filetype, permitting you to run multiple formatters in sequence. To see
   available formatters, run `:h conform-formatters`. To add new formatters for
   a filetype, edit the conform.nvim section in `plugins/custom.lua`
2. [`mason.nvim`](https://github.com/mason-org/mason.nvim): A package manager
   that allows you to manage external tooling like LSP servers, linters, and
   formatters using a single interface. Mason is responsible for the "install"
   window that occurs if you open LazyVim window without a specific file in
   mind (i.e., `$ nvim`).

### Linting

1. [`nvim-lint`](https://github.com/mfussenegger/nvim-lint): Asynchronously
   calls language-specific linter tools and reports their results via the
   `vim.diagnostic` module. Allows us to specify which linters we want to run
   by filetype.

### LSP

1. [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig): A collection
   of LSP server configurations for the Nvim LSP client. To see the available
   configs, run `:h lspconfig-all`. To edit the LSP keybindings, you need to
   add your configuration to the `opts` field in `plugins/custom.lua`. See the
   explanation [here](https://www.lazyvim.org/plugins/lsp#%EF%B8%8F-customizing-lsp-keymaps).
2.
