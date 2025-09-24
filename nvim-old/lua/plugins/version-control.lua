return {
    { 'tpope/vim-fugitive' }, -- use `:G <cmd>` to run a git command
    { 'tpope/vim-rhubarb' },  -- use `:GBrowse` to browse the selected lines on github
    {
        -- Adds git releated signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' }
            }
        }
    }
}
