return {
    {
        -- Toggle comments with Ctrl-/
        'numToStr/Comment.nvim',
        opts = {
            toggler = { line = '<C-/>', block = 'gbc' },
            opleader = { line = '<C-/>', block = 'gb' }
        }
    }
}
