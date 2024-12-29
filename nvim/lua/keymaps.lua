------------------------------------------------------------------------
--                              Keymaps                               --
------------------------------------------------------------------------
-- K : Show function documentation on hover
--
-- CTRL
--    <C-h>     : Display signature help for function under cursor in pop up
--    <C-g>     : Go to the definition of the function under the cursor
--    <C-d>     : Go to the *type* definition for the function under the cursor
--    <C-f>     : Format the current buffer
--    <C-e>     : Show any diagnostic messages for the current line
--    <C-space> : Iteratively select larger and larger code scopes
--
-- g
--   gd     : Go to *Declaration* of variable/function under cursor
--   gi     : Go to the *Implementation* of the variable/function under cursor
--   gr     : Display all *References* to current variable in a new buffer at bottom
--
-- <leader>
--   <leader>ds : Document all symbols in the current *buffer* in a new pop up
--   <leader>ws : Document all symbols in the current *workspace* in a new pop up
--
--   <leader>w  : Save buffer
--   <leader>wa : Add a folder to the current workspace (see bottom of the screen to enter folder path)
--   <leader>wr : Remove a folder from the current workspace (see bottom of the screen to enter folder path)
--   <leader>wl : List all folders in the current worspace
--
--   <leader>rn : Rename all references to the var under the cursor in the current *buffer*
--   <leader>ca : Perform a code action
--
--   <leader><space> : Do recursive grep from current directory. To search
--                     within a parent directory, use "search string" <relative
--                     path> (e.g., "foo" ../../)
--   <leader>sb      : Search within open buffers
--   <leader>s/      : Fuzzy search within the current buffer
--   <leader>s?      : Search recent files by name
--   <leader>sh      : Search help files
--   <leader>sw      : Search for word under corsor in current dir/subdirs
--   <leader>sd      : Search diagnostic messages
--
--   <leader>q  : Replay a series of commands recorded with `qq` by pressing `<leader>q` instead of `@q`
--   <leader>f  : Search files by filename
--   <leader>b  : Open a file navigator from the current directory
--
--        FILE BROWSER OPERATIONS
--        ('<A-*> prefix is 'option' on OSX)
--        <A-c> ....... Create file/folder at current path (trailing path separator creates folder)
--        <A-r> ....... Rename multi-selected files/folders
--        <A-m> ....... Move multi-selected files/folders to current path
--        <A-y> ....... Copy (multi-)selected files/folders to current path
--        <A-d> ....... Delete (multi-)selected filed/folders
--
--        NAVIGATION
--        <C-o> ....... Open file/folder with default system application
--        <C-g> ....... Go up a directory
--        Backspace ... Go up a directory
--        <C-e> ....... Go home
--        <C-w> ....... Go to CWD
--        <C-t> ....... Change nvim's cwd to selected folder/file(parent)
--        <C-h> ....... Toggle hidden files
--
--        SELECTION
--        <C-s> ....... Select/deselect all files in CWD fb
--        <Tab> ....... Toggle a selection and move to the next

local function keymap(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true } -- default options if opts is unspecified
    if opts then options = vim.tbl_extend("force", options, opts) end
    vim.keymap.set(mode, lhs, rhs, options)
end

local T = require('telescope.builtin')
local TH = require('telescope.themes')
local TE = require('telescope').extensions
local WK = require("which-key")
local LSP = vim.lsp.buf

--------------------------------------------
--              Navigation
--------------------------------------------

keymap({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap('n', '<leader>sv', ':luafile $MYVIMRC<CR>', { desc = '[S]ource [V]im config' })

-- Move up and down by larger steps
keymap({ 'n', 'v' }, '<C-k>', '5k')
keymap({ 'n', 'v' }, '<C-j>', '5j')

-- Remap 0 to first non-blank character
keymap('n', '0', '^')

-- Treat long lines as break lines
keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')

-- Keep text selected after indenting/unindenting
keymap({ 'n', 'v', 'o' }, '<', '<gv')
keymap({ 'n', 'v', 'o' }, '>', '>gv')

-- Replay a series of commands recorded with `qq` by pressing `<leader>q` instead of `@q`
keymap({ 'n', 'o' }, '<leader>q', '@q', { desc = '[q] replay recorded commands in buffer q' })

-- Save file with <leader>w
keymap('n', '<leader>w', '<cmd>w!<cr>', { desc = '[w] Save file' })


--------------------------------------------
--                  LSP
--------------------------------------------
keymap('n', 'g[', vim.diagnostic.goto_prev)
keymap('n', 'g]', vim.diagnostic.goto_next)

-- Use LspAttach autocommand to only map the following keys after the language
-- server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        keymap('n', 'gd', LSP.declaration, { buffer = ev.buf, desc = "[G]o to [D]eclaration" })
        keymap('n', 'gi', LSP.implementation, { buffer = ev.buf, desc = "[G]o to [i]mplementation" })
        keymap('n', 'gr', LSP.references, { buffer = ev.buf, desc = "[G]o to [r]eferences" })


        keymap('n', 'K', LSP.hover, { buffer = ev.buf, desc = "Show function doc on hover" })

        keymap('n', '<C-h>', LSP.signature_help, { buffer = ev.buf, desc = "Signature [h]elp" })
        keymap('n', '<C-g>', LSP.definition, { buffer = ev.buf, desc = "[G]o to [d]efinition" })
        keymap('n', '<C-d>', LSP.type_definition, { buffer = ev.buf, desc = 'Go to [d]efinition' })
        keymap('n', '<C-f>', function() LSP.format { async = true } end, { buffer = ev.buf, desc = "[F]ormat code" })

        keymap('n', '<leader>ds', T.lsp_document_symbols, { buffer = ev.buf, desc = '[D]ocument [S]ymbols' })
        keymap('n', '<leader>ws', T.lsp_dynamic_workspace_symbols, { buffer = ev.buf, desc = '[W]orkspace [S]ymbols' })
        keymap('n', '<leader>wa', LSP.add_workspace_folder, { buffer = ev.buf, desc = "[W]orkspace [a]dd" })
        keymap('n', '<leader>wr', LSP.remove_workspace_folder, { buffer = ev.buf, desc = "[W]orkspace [r]emove" })
        keymap('n', '<leader>rn', LSP.rename, { buffer = ev.buf, desc = "[R]e[n]ame" })
        keymap('n', '<leader>ca', LSP.code_action, { buffer = ev.buf, desc = "[C]ode [a]ction" })
        keymap('n', '<leader>wl', function() print(vim.inspect(LSP.list_workspace_folders())) end,
            { buffer = ev.buf, desc = '[W]orkspace [l]ist' })
    end
})


-- file browser via <leader>b
-- vim.api.nvim_set_keymap("n", "<leader>b",
--     ":Telescope file_browser path=%:p:h select_buffer=true<cr>",
--     { desc = 'File [B]rowser', noremap = true })

-- buffer search via <leader>b
keymap('n', '<leader>b', T.buffers, { desc = 'Search open [B]uffers' })

-- search files via <leader>f
keymap('n', '<leader>f', T.find_files, { desc = 'Search [F]iles' })

-- do livegrep via <leader><space>
keymap('n', '<leader><space>', TE.live_grep_args.live_grep_args,
    { desc = '[ ] Search by grep' })

-- toggle most recent buffer with CTRL-6

-- exit terminal entry mode with ESC
keymap('t', '<ESC>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

local leader = {
    ['s'] = {
        name = "+telescope",
        ['b'] = { T.buffers, "[S]earch [b]uffers" },
        ['/'] = {
            function() T.current_buffer_fuzzy_find(TH.get_dropdown({ previewer = false })) end,
            "Fuzzy search in buffer"
        },
        ['?'] = { T.oldfiles, "[S]earch recent files" },
        ['h'] = { T.help_tags, "[S]earch [h]elp" },
        ['w'] = { T.grep_string, "[S]earch [w]ord" },
        ['d'] = { T.diagnostics, "[S]earch [d]iagnostics" }
    }
    --     ["f"] = {
    --         name = "+telescope",
    --         ["f"] = { "<cmd> Telescope find_files <CR>", "Find Files" },
    --         ["a"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find All Files" },
    --         ["e"] = { "<cmd> Telescope file_browser <CR>", "File Browser" },
    --         ["w"] = { "<cmd> Telescope live_grep <CR>", "Live Grep" },
    --         ["b"] = { "<cmd> Telescope buffers <CR>", "Buffers" },
    --         ["h"] = { "<cmd> Telescope help_tags <CR>", "Help Tags" },
    --         ["o"] = { "<cmd> Telescope oldfiles <CR>", "Old Files" },
    --         ["c"] = { "<cmd> Telescope colorscheme <CR>", "Colorschemes" },
    --     },
    --     ["<TAB>"] = {
    --         name = "+tab",
    --         ["<tab>"] = { "<cmd>tabnew<CR>", "New Tab" },
    --         ["n"] = { "<cmd>tabnext<CR>", "Next" },
    --         ["d"] = { "<cmd>tabclose<CR>", "Close" },
    --         ["p"] = { "<cmd>tabprevious<CR>", "Previous" },
    --     },
    --     ["b"] = {
    --         name = "+buffer",
    --         ["d"] = { "<cmd>bd<CR>", "Delete Buffer" },
    --         ["n"] = { "<cmd>BufferLineCycleNext<CR>", "Next Buffer" },
    --         ["p"] = { "<cmd>BufferLineCyclePrev<CR>", "Prev Buffer" },
    --         ["c"] = { "<cmd>BufferLinePickClose<CR>", "Close Buffer" },
    --         ["m"] = {
    --             name = "+move",
    --             ["n"] = { "<cmd>BufferLineMoveNext<CR>", "Next Buffer" },
    --             ["p"] = { "<cmd>BufferLineMovePrev<CR>", "Prev Buffer" },
    --         },
    --     },
    --     ["o"] = {
    --         name = "+open",
    --         ["t"] = { "<cmd> ToggleTerm size=20<CR>", "Terminal" },
    --         ["f"] = { "<cmd> NvimTreeToggle<CR>", "File Explorer" },
    --         ["d"] = { "<cmd> DiffviewOpen<CR>", "DiffView" },
    --         ["g"] = { "<cmd> Neogit<CR>", "Neogit" },
    --     },
    --     ["u"] = { "<cmd> UndotreeToggle<CR>", "Undo Tree" },
    --     ["g"] = {
    --         name = "+goto",
    --         ["d"] = { "<cmd> Telescope lsp_definitions<CR>", "Definition" },
    --         ["i"] = { "<cmd> Telescope lsp_implementation<CR>", "Implementation" },
    --         ["r"] = { "<cmd> Telescope lsp_references<CR>", "References" },
    --     },
    --     ["c"] = {
    --         name = "+code",
    --         ["r"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    --         ["f"] = { "<cmd> FormatWrite<CR>", "Format Document" },
    --     },
}
--
WK.register(leader, { prefix = "<leader>" })
