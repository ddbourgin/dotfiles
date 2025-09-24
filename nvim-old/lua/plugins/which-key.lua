return {
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            local links = {
                [""] = "Function",      -- the key
                Group = "Keyword",      -- a group
                Separator = "Comment",  -- the separator between the key and its label
                Desc = "Identifier",    -- the label of the key
                Float = "Constant",     -- Normal in the popup window "NormalFloat",
                Border = "FloatBorder", -- Normal in the popup window
                Value = "Comment"       -- used by plugins that provide values
            }

            -- set color schemes
            for k, v in pairs(links) do
                vim.api.nvim_set_hl(0, "WhichKey" .. k,
                    { link = v, default = true })
            end

            require("which-key").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
                --     show_help = false,
                --     show_keys = false,
                key_labels = { ["<leader>"] = "SPC" }
            })
        end
    }
}
