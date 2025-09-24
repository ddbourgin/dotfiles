return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        },
        event = "VeryLazy",
        config = function()
            require("harpoon").setup({})
            local harpoon = require("harpoon")

            harpoon:setup()

            -- <C-l>: toggle harpoon list
            -- <C-a>: append file to list
            -- <leader>[1-6] open list item [1-6]
            -- <leader>v[1-6] open list item [1-6] in vertical split
            -- <leader>v[1-6] open list item [1-6] in horizontal split
            vim.keymap.set("n", "<C-a>", function()
                harpoon:list():add()
            end, { desc = 'Harpoon: [a]ppend file to list' })
            vim.keymap.set("n", "<C-l>", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
                -- toggle_telescope(harpoon:list())
            end, { desc = 'Toggle Harpoon [l]ist' })
            -- move to previous file in harpoon list with <C-;>
            vim.keymap.set("n", "<C-;>", function()
                harpoon:list():prev()
            end, { desc = 'Harpoon: Move back one entry in list' })
            -- move to next file in harpoon list with <C-'>
            vim.keymap.set("n", "<C-'>", function()
                harpoon:list():next()
            end, { desc = 'Harpoon: Move forward one entry in list' })
            vim.keymap.set("n", "<leader>1", function()
                harpoon:list():select(1)
            end, { desc = 'Harpoon: Open item 1' })
            vim.keymap.set("n", "<leader>v1", function()
                harpoon:list():select(1, { vsplit = true })
            end, { desc = 'Harpoon: Open item 1 in a [v]ertical split' })
            vim.keymap.set("n", "<leader>h1", function()
                harpoon:list():select(1, { hsplit = true })
            end, { desc = 'Harpoon: Open item 1 in a [h]orizontal split' })
            vim.keymap.set("n", "<leader>2", function()
                harpoon:list():select(2)
            end, { desc = 'Harpoon: Open item 2' })
            vim.keymap.set("n", "<leader>v2", function()
                harpoon:list():select(2, { vsplit = true })
            end, { desc = 'Harpoon: Open item 2 in a [v]ertical split' })
            vim.keymap.set("n", "<leader>h2", function()
                harpoon:list():select(2, { vsplit = true })
            end, { desc = 'Harpoon: Open item 2 in a [h]orizontal split' })
            vim.keymap.set("n", "<leader>3", function()
                harpoon:list():select(3)
            end, { desc = 'Harpoon: Open item 3' })
            vim.keymap.set("n", "<leader>v3", function()
                harpoon:list():select(3, { vsplit = true })
            end, { desc = 'Harpoon: Open item 3 in a [v]ertical split' })
            vim.keymap.set("n", "<leader>h3", function()
                harpoon:list():select(3, { hsplit = true })
            end, { desc = 'Harpoon: Open item 3 in a [h]orizontal split' })
            vim.keymap.set("n", "<leader>4", function()
                harpoon:list():select(4)
            end, { desc = 'Harpoon: Open item 4' })
            vim.keymap.set("n", "<leader>v4", function()
                harpoon:list():select(4, { vsplit = true })
            end, { desc = 'Harpoon: Open item 4 in a [v]ertical split' })
            vim.keymap.set("n", "<leader>h4", function()
                harpoon:list():select(4, { hsplit = true })
            end, { desc = 'Harpoon: Open item 4 in a [h]orizontal split' })
            vim.keymap.set("n", "<leader>5", function()
                harpoon:list():select(5)
            end, { desc = 'Harpoon: Open item 5' })
            vim.keymap.set("n", "<leader>v5", function()
                harpoon:list():select(5, { vsplit = true })
            end, { desc = 'Harpoon: Open item 5 in a [v]ertical split' })
            vim.keymap.set("n", "<leader>h5", function()
                harpoon:list():select(5, { hsplit = true })
            end, { desc = 'Harpoon: Open item 5 in a [h]orizontal split' })
            vim.keymap.set("n", "<leader>6", function()
                harpoon:list():select(6)
            end, { desc = 'Harpoon: Open item 6' })
            vim.keymap.set("n", "<leader>v6", function()
                harpoon:list():select(6, { vsplit = true })
            end, { desc = 'Harpoon: Open item 6 in a [v]ertical split' })
            vim.keymap.set("n", "<leader>h6", function()
                harpoon:list():select(6, { hsplit = true })
            end, { desc = 'Harpoon: Open item 6 in a [h]orizontal split' })
        end
    }
}
