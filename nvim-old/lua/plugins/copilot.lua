return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = {
                    enabled = false,
                    auto_refresh = true,
                },
                copilot_node_command = vim.fn.expand("$HOME") .. "/.nvm/versions/node/v19.8.1/bin/node", -- Node.js version must be > 16.x
            })
        end,
    }
}
