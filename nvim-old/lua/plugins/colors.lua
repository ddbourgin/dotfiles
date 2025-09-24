return {
    {
        -- show color codes in their color
        "NvChad/nvim-colorizer.lua",
        config = function()
            require('colorizer').setup({
                user_default_options = {
                    RGB      = true,         -- #RGB hex codes
                    RRGGBB   = true,         -- #RRGGBB hex codes
                    names    = false,        -- "Name" codes like Blue
                    RRGGBBAA = true,         -- #RRGGBBAA hex codes
                    rgb_fn   = true,         -- CSS rgb() and rgba() functions
                    hsl_fn   = true,         -- CSS hsl() and hsla() functions
                    css      = false,        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                    css_fn   = true,         -- Enable all CSS *functions*: rgb_fn, hsl_fn
                    mode     = 'background', -- Set the display mode.
                }
            })
        end
    },
    {
        -- Colorscheme (requires termguicolors)
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
        config = function()
            vim.api.nvim_set_option("background", "dark")
            local C = {
                black = "#003440",
                blue = "#268ad1",
                cyan = "#2aa097",
                gray = "#9ca09f",
                green = "#7cc67f",
                orange = "#f86100",
                purple = "#d23581",
                red = "#db312f",
                white = "#eee7d4",
                yellow = "#b48800",
                violet = "#6c71c4",
                dark_purple = "#aacccd",
                bright_black = "#00779a",
                bright_blue = "#119fd2",
                bright_cyan = "#00bdae",
                bright_gray = "#8ca09f",
                bright_green = "#5bee96",
                bright_orange = "#f86100",
                bright_purple = "#e9679f",
                bright_red = "#f9314b",
                bright_white = "#fdf5e2",
                bright_yellow = "#c08f34",
                olive = "#7d7461",
                light_pink = "#f7b2b7",
                background = "#002833",
                foreground = "#aacccd",
                base01 = "#839496"
            }
            require("onedarkpro").setup({
                colors = {
                    -- onedark_vivid = {
                    --     black = C.black,
                    --     blue = C.bright_blue,
                    --     cyan = C.bright_cyan,
                    --     gray = C.bright_gray,
                    --     green = C.bright_green,     -- C.bright_purple,
                    --     orange = C.orange,
                    --     purple = C.bright_purple,
                    --     red = C.red,
                    --     white = C.foreground,
                    --     yellow = C.yellow,
                    --     comment = C.bright_cyan,
                    --     bg = C.background,
                    --     fg = C.foreground
                    -- }
                    onedark_vivid = {
                        green = C.bright_cyan, -- C.violet, -- C.bright_purple,
                        cyan = C.bright_cyan,  -- C.bright_cyan,
                        black = C.black,
                        blue = C.bright_blue,
                        gray = C.bright_gray,
                        orange = C.orange,
                        purple = C.bright_purple,
                        red = C.foreground,
                        white = C.foreground,
                        yellow = C.yellow,
                        comment = C.base01,
                        bg = C.background,
                        fg = C.foreground
                    }
                },
                highlights = {
                    ------------------------------------------------------------------------
                    --                            Constructors                            --
                    ------------------------------------------------------------------------
                    -- ['Special']                       = { fg = C.foreground },
                    -- ['@constructor'] = { fg = C.bright_cyan, style = 'bold' },
                    ------------------------------------------------------------------------
                    --                             Variables                              --
                    ------------------------------------------------------------------------
                    -- ['@variable']                     = { fg = C.foreground },  -- Any variable name that does not have another highlighC
                    -- ['@variable.parameter']           = { fg = C.dark_purple }, -- For fields
                    -- ['@variable.member']              = { fg = C.foreground },  -- For parameters of a function
                    ['@variable.constant.type'] = { style = 'bold' },
                    -- ['@variable.constant.builtin']    = { fg = C.foreground },  -- Var names defined by the language: this, self, super
                    ------------------------------------------------------------------------
                    --                             Functions                              --
                    ------------------------------------------------------------------------
                    -- ['@method'] = { fg = C.foreground },
                    ['@function.builtin']       = { style = 'bold' },
                    ------------------------------------------------------------------------
                    --                            Punctuation                             --
                    ------------------------------------------------------------------------
                    -- ['@punctuation.bracket.lua']      = { fg = C.foreground },
                    ------------------------------------------------------------------------
                    --                     Python-Specific Highlights                     --
                    ------------------------------------------------------------------------
                    ['@include.python']         = { style = 'bold' },
                    -- ['@keyword.return']               = { fg = C.yellow },
                    ['@function.python']        = { style = 'bold' },
                    -- ['@method.call.python']           = { fg = C.foreground },
                    -- ['@conditional.python']           = { fg = C.yellow },
                    ['@type.builtin.python']    = { style = 'bold' },
                    -- ['@keyword.function.python']      = { fg = C.yellow },
                    -- ['@odp.keyword.python']           = { fg = C.foreground },
                    ['@odp.constructor.python'] = { style = 'bold' },
                    -- ['@odp.punctuation.brace.python'] = { fg = C.foreground },
                    ------------------------------------------------------------------------
                    --                            Basic Types                             --
                    ------------------------------------------------------------------------
                    -- ['@type']                         = { fg = C.foreground },
                    ['@type.builtin']           = { style = 'bold' },
                    -- ['@repeat']                       = { fg = C.yellow },
                    -- ['@number']                       = { fg = C.bright_purple },
                    -- ['@string']                       = { fg = C.bright_purple },
                    -- ['@method']                       = { fg = C.bright_cyan },
                    -- ['@preproc']                      = { fg = C.bright_cyan },
                    -- ['@constant']                     = { fg = C.foreground },
                    -- ['@operator']                     = { fg = C.foreground },
                    -- ['@parameter']                    = { fg = C.foreground },
                    -- ['@attribute']                    = { fg = C.bright_cyan, style = 'bold' },
                },
            })
            vim.cmd [[ colorscheme onedark_vivid ]]
        end
    }
}
