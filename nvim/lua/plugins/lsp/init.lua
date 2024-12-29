require("plugins.lsp.diagnostics")

return {
    {
        -- PLUGIN: nvim-lspconfig =>
        -- Quickstart configs for Nvim LSP
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            -- PLUGIN cmp-nvim-lsp =>
            -- Completion engine for neovim
            "hrsh7th/cmp-nvim-lsp",
            -- PLUGIN fidget.nvim =>
            -- status updates for LSP
            { 'j-hui/fidget.nvim', opts = {} },
            -- PLUGIN neodev =>
            -- Additional lua configuration, makes nvim stuff amazing!
            { 'folke/neodev.nvim', opts = {} }
        },
    },
    {
        -- PLUGIN: mason.nvim =>
        -- Automatically install formatters/linters to be used by null-ls
        "williamboman/mason.nvim",
        event = "VeryLazy",
        cmd = "Mason",
        dependencies = {
            "neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim", "jose-elias-alvarez/null-ls.nvim",
            "jayp0521/mason-null-ls.nvim",
        },
        config = function()
            require("mason").setup({})
            require("mason-lspconfig").setup({ automatic_installation = true })
            require("mason-lspconfig").setup_handlers({
                function()
                    local capabilities =
                        require("cmp_nvim_lsp").default_capabilities(vim.lsp
                            .protocol
                            .make_client_capabilities())
                    capabilities.offsetEncoding = { "utf-16" }

                    local servers = require("plugins.lsp.servers")

                    local handlers = {
                        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
                        ["textDocument/signatureHelp"] = vim.lsp.with(
                            vim.lsp.handlers.signature_help,
                            { border = "single" }
                        ),
                    }

                    for server, opts in pairs(servers) do
                        opts.capabilities = capabilities
                        opts.handlers = handlers

                        local lspconfig_server = require("lspconfig")[server]
                        if lspconfig_server and lspconfig_server.setup then
                            lspconfig_server.setup(opts)
                        end
                        -- require("lspconfig")[server].setup(opts)
                    end
                end
            })
            require("mason-null-ls").setup({
                automatic_installation = true,
            })
        end
    },
    {
        --PLUGIN: null-ls =>
        -- Use Neovim as a language server to inject LSP diagnostics, code actions, etc.
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            null_ls.setup({
                on_init = function(new_client, _) new_client.offset_encoding = "utf-16" end,
                sources = {
                    -- null_ls.builtins.diagnostics.eslint_d, -- javascript
                    null_ls.builtins.diagnostics.xo,       -- javascript
                    null_ls.builtins.diagnostics.mypy,     -- python
                    null_ls.builtins.diagnostics.ruff,     -- python
                    null_ls.builtins.diagnostics.jsonlint, -- json
                    null_ls.builtins.diagnostics.luacheck.with({
                        allow_defined = true
                    }),                                        -- lua
                    null_ls.builtins.diagnostics.markdownlint, -- markdown
                    null_ls.builtins.diagnostics.shellcheck,   -- sh
                    null_ls.builtins.diagnostics.vint,         -- vimscript
                    null_ls.builtins.diagnostics.yamllint,     -- yaml

                    null_ls.builtins.completion.spell,         -- spelling

                    null_ls.builtins.formatting.isort,         -- python
                    null_ls.builtins.formatting.black,         -- python
                    null_ls.builtins.formatting.beautysh,      -- shell
                    null_ls.builtins.formatting.shellharden,   -- shell
                    null_ls.builtins.formatting.clang_format,  -- C
                    null_ls.builtins.formatting.eslint_d,      -- javascript
                    null_ls.builtins.formatting.jq,            -- json
                    null_ls.builtins.formatting.markdownlint,  -- markdown
                    null_ls.builtins.formatting.scalafmt,      -- scala
                    null_ls.builtins.formatting.stylelint,     -- css
                    null_ls.builtins.formatting.tidy,          --
                    null_ls.builtins.formatting.trim_newlines, -- trim endlines
                    null_ls.builtins.formatting.yq,            --

                    null_ls.builtins.hover.dictionary,
                },
                on_attach = function(client, bufnr)
                    -- format files on save
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end
                        })
                    end

                    -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131#issuecomment-12738435310
                    -- fix `gq` behavior for formatting wrapped lines
                    local function is_null_ls_formatting_enabed(bnr)
                        local file_type = vim.api.nvim_buf_get_option(bnr, "filetype")
                        local generators = require("null-ls.generators").get_available(
                            file_type,
                            require("null-ls.methods").internal.FORMATTING
                        )
                        return #generators > 0
                    end

                    if client.server_capabilities.documentFormattingProvider then
                        if
                            client.name == "null-ls" and is_null_ls_formatting_enabed(bufnr)
                            or client.name ~= "null-ls"
                        then
                            vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
                            vim.keymap.set(
                                "n", "gq", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
                                { noremap = true, silent = true }
                            )
                        else
                            vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")
                        end
                    end
                end
            })
        end,
    }
}
