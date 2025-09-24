vim.diagnostic.config({
    underline = false,
    update_in_insert = false,
    virtual_text = false,
    -- virtual_text = { spacing = 4, prefix = " ●" },
    severity_sort = true,
    float = {
        source = "always", -- Or "if_many"
    },
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- view diagnostic messages by putting cursor on line and pressing <C-e>
vim.api.nvim_set_keymap(
    'n', '<C-e>', ':lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

-- print diagnostics to statusline
-- function PrintDiagnostics(opts, bufnr, line_nr, client_id)
--     bufnr = bufnr or 0
--     line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
--     opts = opts or { ['lnum'] = line_nr }
--
--     local line_diagnostics = vim.diagnostic.get(bufnr, opts)
--     if vim.tbl_isempty(line_diagnostics) then return end
--
--     local diagnostic_message = ""
--     for i, diagnostic in ipairs(line_diagnostics) do
--         diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
--         print(diagnostic_message)
--         if i ~= #line_diagnostics then
--             diagnostic_message = diagnostic_message .. "\n"
--         end
--     end
--     vim.api.nvim_echo({ { diagnostic_message, "Normal" } }, false, {})
-- end
--
-- vim.cmd [[ autocmd! CursorHold * lua PrintDiagnostics() ]]

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics, {
--         -- Disable underline, it's very annoying
--         underline = false, -- {severity = "ERROR" },
--         virtual_text = false,
--         -- Enable virtual text, override spacing to 4
--         -- virtual_text = {spacing = 4},
--         -- Use a function to dynamically turn signs off
--         -- and on, using buffer local variables
--         signs = true,
--         -- update_in_insert = false
--     }
-- )
