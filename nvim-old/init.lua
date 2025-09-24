-- Set <space> as the leader key
-- Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ordinary neovim setup
require("settings")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "--single-branch",
        "https://github.com/folke/lazy.nvim.git", lazypath
    })
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup(
    "plugins",
    {
        -- debug = true,
        checker = { enabled = false },
        change_detection = { notify = false },
        performance = {
            rtp = {
                disabled_plugins = {
                    -- "gzip",
                    -- "matchit",
                    -- "matchparen",
                    -- "netrwPlugin",
                    -- "tarPlugin",
                    -- "tohtml",
                    -- "tutor",
                    -- "zipPlugin",
                }
            }
        },
    }
)

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("keymaps")
        require("commands")
    end,
})

if vim.g.vscode then
    require("vscode_keymaps")
end
