-- Return to the last edit position when opening files
vim.cmd [[
autocmd BufReadPost *
            \ if line("'\"")> 0 && line("'\"") <= line("$") |
            \ exe "normal! g`\"" |
            \ endif
]]

local API = vim.api


-- Highlight on yank
local highlight_group = API.nvim_create_augroup('YankHighlight', { clear = true })
API.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank() end,
    group = highlight_group,
    pattern = '*'
})

-- Enable the following language servers
local servers = {
    clangd = {},
    -- gopls = {},
    rust_analyzer = {},
    pyright = {},
    tsserver = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false }
        }
    }
}
