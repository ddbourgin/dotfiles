return {
    {
        --Treesitter builds an internal graph representation of any code opened
        --in the editor which can then be used by plugins authors to write
        --plugins and for better than normal syntax highlighting.
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'nvim-treesitter/playground'
        },
        config = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })

            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    'c',
                    'cpp',
                    'lua',
                    'python',
                    'rust',
                    'javascript',
                    'tsx',
                    'typescript',
                    'help',
                    'vim',
                    'scala',
                    'java',
                    'html',
                    'css'
                },
                auto_install = true,
                highlight = { enable = true },
                -- indent = { enable = true, disable = { 'python' } },
                autotag = {
                    enable = true,
                    filetypes = { 'html', 'typescriptreact', 'javascriptreact' },
                },
                rainbow = {
                    enable = true,
                    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                    max_file_lines = nil, -- Do not enable for files with more than n lines, int
                    -- colors = {}, -- table of hex strings
                    -- termcolors = {} -- table of colour name strings
                },
                autopairs = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<c-space>',
                        node_incremental = '<c-space>',
                        scope_incremental = '<c-s>',
                        node_decremental = '<M-space>'
                    }
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- you can use the capture groups defined in textobjects.scm
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner'
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            [']m'] = '@function.outer',
                            [']]'] = '@class.outer'
                        },
                        goto_next_end = {
                            [']M'] = '@function.outer',
                            [']['] = '@class.outer'
                        },
                        goto_previous_start = {
                            ['[m'] = '@function.outer',
                            ['[['] = '@class.outer'
                        },
                        goto_previous_end = {
                            ['[M'] = '@function.outer',
                            ['[]'] = '@class.outer'
                        }
                    },
                    swap = {
                        enable = true,
                        swap_next = { ['<leader>a'] = '@parameter.inner' },
                        swap_previous = { ['<leader>A'] = '@parameter.inner' }
                    }
                }
            }
        end
    }
}
