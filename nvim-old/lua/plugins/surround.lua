return {
    {
        -- Surround text
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                surrounds = {
                    ["b"] = { -- \textbf
                        add = function()
                            return { { "\\textbf{" }, { "}" } }
                        end,
                        find = function()
                        end,
                        delete = function()
                        end,
                    },
                    ["e"] = {
                        add = function()
                            return { { "\\emph{" }, { "}" } }
                        end,
                        find = function()
                        end,
                        delete = function()
                        end,
                    },
                    ["I"] = {
                        add = function()
                            return { { "\\begin{itemize} \t \\item " }, { "\\end{itemize}" } }
                        end,
                        find = function()
                        end,
                        delete = function()
                        end,
                    },
                    ["E"] = {
                        add = function()
                            return { { "\\begin{enumerate} \t \\item " }, { "\\end{enumerate}" } }
                        end,
                        find = function()
                        end,
                        delete = function()
                        end,
                    },
                },
                highlight = { duration = 10 },
                aliases = {
                    ["a"] = ">",
                    -- ["b"] = ")",
                    ["B"] = "}",
                    ["r"] = "]",
                    ["q"] = { '"', "'", "`" },
                    ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
                },
            })
        end
    }
}
