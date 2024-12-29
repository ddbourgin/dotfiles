return {
    {
        -- neovim web devicons
        'nvim-tree/nvim-web-devicons'
    },
    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                icons_enabled = true,
                theme = 'onedark',
                component_separators = '|',
                section_separators = ''
            }
        }
    },
    {
        -- Show a tabline with open buffers
        'romgrk/barbar.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        init = function() vim.g.barbar_auto_setup = false end,
        opts = {
            clickable = false,
            icons = {
                inactive = { button = '' },
            }
        },
        version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },
    {
        -- Local highlight
        "tzachar/local-highlight.nvim",
        event = "BufReadPost",
        config = function()
            require("local-highlight").setup({
                file_types = { "*" },
            })
        end,
    },
    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        main = "ibl",
        config = function()
            require('ibl').setup {
                indent = { char = '|' }, -- "¦", "┆", "┊", "▏"
                exclude = {
                    filetypes = {
                        "startify", "dashboard", "dotooagenda", "log", "fugitive",
                        "gitcommit", "packer", "vimwiki", "markdown", "json", "txt",
                        "vista", "help", "todoist", "NvimTree", "neo-tree", "peekaboo",
                        "git", "TelescopePrompt", "undotree", "flutterToolsOutline", ""
                        -- for all buffers without a file type
                    }
                },
            }
        end,
    }
}
