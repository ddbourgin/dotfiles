return {
    {
        -- Fuzzy Finder (files, LSP, etc):
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'piersolenski/telescope-import.nvim' },
            { "nvim-telescope/telescope-file-browser.nvim" },
            { "nvim-telescope/telescope-live-grep-args.nvim" }
        },
        config = function()
            require("telescope").load_extension("import")
            require("telescope").load_extension("file_browser")
            require("telescope").load_extension("live_grep_args")

            vim.keymap.set("n", "<leader>i", function()
                require("telescope").extensions.import.import()
            end, { desc = 'Search [i]mports across files in project' })

            local colors = {
                background = "#002833",
                foreground = "#aacccd",
                yellow = "#b48800",
                magenta = "#d23581",
                green = "#2aa097",
                red = "#db312f",
                orange = "#f86100",
                blue = "#268ad1"
            }

            local TelescopeColor = {
                TelescopeSelection = {
                    fg = colors.background,
                    bg = colors.magenta,
                    bold = true
                },
                TelescopeResultsNormal = { bg = colors.background },
                TelescopePreviewNormal = { bg = colors.background },
                TelescopeResultsBorder = {
                    bg = colors.background,
                    fg = colors.yellow
                },
                TelescopePreviewBorder = {
                    bg = colors.background,
                    fg = colors.yellow
                },
                TelescopePromptNormal = {
                    bg = colors.background,
                    fg = colors.white
                },
                TelescopePromptBorder = {
                    bg = colors.background,
                    fg = colors.yellow
                },
                -- TelescopeMatching = { bg = colors.yellow, fg = colors.background },
                TelescopePreviewTitle = { bg = colors.background, fg = colors.yellow },
                TelescopePromptPrefix = { fg = colors.yellow, bg = colors.background },
                TelescopePromptTitle = { bg = colors.background, fg = colors.yellow },
                TelescopeResultsTitle = { fg = colors.yellow, bg = colors.background },
            }

            for hl, col in pairs(TelescopeColor) do
                vim.api.nvim_set_hl(0, hl, col)
            end

            local actions = require("telescope.actions")

            require("telescope").setup({
                set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous
                        }
                    }
                }
            })
        end
    },
    {
        -- Compiled fzf algo in C for faster sorting
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end
    },
    {
        "nvim-telescope/telescope-live-grep-args.nvim"
    }
}
