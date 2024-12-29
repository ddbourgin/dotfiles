return {
    {
        "lervag/vimtex",
        config = function()
            vim.g.tex_flavor = "latex"
            if vim.fn.has("unix") == 1 then
                vim.gvimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
                vim.g.vimtex_view_general_options = '-r @line @pdf @tex'
                vim.g.vimtex_view_method = "skim"
                vim.g.vimtex_view_skim_sync = 1
                vim.g.vimtex_view_skim_activate = 1
            end

            -- The quickfix window is never opened/closed automatically.
            vim.g.vimtex_quickfix_mode = 0

            -- Compile and view LaTeX documents with <leader> b
            vim.api.nvim_create_autocmd(
                { "FileType" }, {
                    pattern = { "tex" },
                    callback = function()
                        vim.cmd [[ nmap <buffer> <leader>b :w!<cr>:VimtexCompile<cr>:VimtexView<cr> ]]
                    end,
                }
            )

            -- ignore the `can't use callbacks without + clientserver` error
            vim.g.vimtex_disable_version_warning = 2

            -- disable/enable VimTeX indentation.
            vim.g.vimtex_indent_enabled = 1

            vim.g.vimtex_fold_enabled = 0
            vim.g.tex_flavor = 'latex'

            -- comments at end of lines will not be joined with the |gq| command, and
            -- environments like `equation` will not be joined/changed.
            vim.g.vimtex_format_enabled = 1

            -- Turn off rendering of LaTeX backslash commands to unicode characters
            -- a=conceal accents/ligatures
            -- d=conceal delimiters
            -- g=conceal Greek
            -- m=conceal math symbols
            -- s=conceal superscripts/subscripts
            vim.g.tex_conceal = ""
            vim.g.vimtex_syntax_conceal_disable = 1
        end
    }
}
