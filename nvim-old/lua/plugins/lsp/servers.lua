return {
    clangd = {},
    gopls = {},
    astro = {},
    bashls = {},
    jdtls = {},
    cssls = {},
    dockerls = {},
    tsserver = {},
    svelte = {},
    eslint = {
        filetypes = {
            "javascript", "javascriptreact", "javascript.jsx", "typescript",
            "typescriptreact", "typescript.tsx"
        }
    },
    html = {},
    pyright = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
    yamlls = {},
    tailwindcss = {},
    texlab = {},
    volar = {}
}
