return {
    {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end
    },
    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'SirVer/ultisnips',
            "honza/vim-snippets",
            'quangnguyen30192/cmp-nvim-ultisnips',
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            'zbirenbaum/copilot-cmp',
        },
        config = function()
            local cmp = require('cmp')
            require("cmp_nvim_ultisnips").setup({})
            local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

            vim.g.UltiSnipsExpandTrigger = "<Tab>"
            vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }

            local lsp_symbols = {
                Copilot = ' (Copilot)',
                Text = "   (Text) ",
                Method = "   (Method)",
                Function = "   (Function)",
                Constructor = "   (Constructor)",
                Field = " ﴲ  (Field)",
                Variable = "[] (Variable)",
                Class = "   (Class)",
                Interface = " ﰮ  (Interface)",
                Module = "   (Module)",
                Property = " 襁 (Property)",
                Unit = "   (Unit)",
                Value = "   (Value)",
                Enum = " 練 (Enum)",
                Keyword = "   (Keyword)",
                Snippet = "   (Snippet)",
                Color = "   (Color)",
                File = "   (File)",
                Reference = "   (Reference)",
                Folder = "   (Folder)",
                EnumMember = "   (EnumMember)",
                Constant = " ﲀ  (Constant)",
                Struct = " ﳤ  (Struct)",
                Event = "   (Event)",
                Operator = "   (Operator)",
                TypeParameter = "   (TypeParameter)"
            }
            local has_words_before = function()
                if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
            end
            require('cmp').setup {
                enabled = function()
                    -- disable completion in comments
                    local context = require('cmp.config.context')
                    -- Disable in buf-type prompts
                    local buftype = vim.api.nvim_buf_get_option(0, 'buftype')

                    if buftype == 'prompt' then
                        return false
                    end

                    -- keep command mode completion enabled when cursor is in a comment
                    if vim.api.nvim_get_mode().mode == 'c' then
                        return true
                    else
                        return not context.in_treesitter_capture('comment') and not context.in_syntax_group('Comment')
                    end
                end,
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        -- require('cmp.config.compare').score,
                        require("copilot_cmp.comparators").prioritize,

                        -- Below is the default comparitor list and order for nvim-cmp
                        cmp.config.compare.offset,
                        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
                -- preselect = cmp.PreselectMode.None, -- don't preselect items in menu
                snippet = { expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end },
                sources = {
                    { name = "path" },
                    { name = 'nvim_lsp_signature_help' },
                    { name = "copilot",                group_index = 1 },
                    { name = "nvim_lsp" },
                    { name = "spell" },
                    { name = 'ultisnips' }
                },
                mapping = {
                    ["<C-j>"] = cmp.mapping(function(fallback)
                        cmp_ultisnips_mappings.jump_forwards(fallback)
                    end, { "i", "s" }),
                    ["<C-k>"] = cmp.mapping(function(fallback)
                        cmp_ultisnips_mappings.jump_backwards(fallback)
                    end, { "i", "s" }),
                    ['<Tab>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                },
                formatting = {
                    fields = { 'kind', 'abbr', 'menu' },
                    format = function(entry, item)
                        item.kind = lsp_symbols[item.kind] .. " " .. item.kind
                        item.menu =
                            ({
                                spell = "[Spell]",
                                buffer = "[Buffer]",
                                calc = "[Calc]",
                                nvim_lsp = "[LSP]",
                                path = "[Path]",
                                treesitter = "[Treesitter]",
                                copilot_cmp = "[Copilot]",
                                -- look = "[Look]",
                                -- emoji = "[Emoji]",
                                -- nvim_lua = "[Lua]",
                                -- luasnip = "[LuaSnip]",
                                -- cmp_tabnine = "[Tab9]"
                                -- latex_symbols = "[Latex]",
                            })[entry.source.name]
                        return item
                    end
                },
            }
        end,
    }
}
