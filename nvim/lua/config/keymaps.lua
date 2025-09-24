-- Keymaps are automatically loaded on the VeryLazy event
--
-- LazyVim default keymaps that are already set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local function keymap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true } -- default options if opts is unspecified
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

--------------------------------------------
--              Navigation
--------------------------------------------

keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap("n", "<leader>sv", ":luafile $MYVIMRC<CR>", { desc = "[S]ource [V]im config" })

-- Move up and down by larger steps
keymap({ "n", "v" }, "<C-k>", "5k")
keymap({ "n", "v" }, "<C-j>", "5j")

-- Remap 0 to first non-blank character
keymap("n", "0", "^")

-- Treat long lines as break lines
keymap("n", "j", "gj")
keymap("n", "k", "gk")

-- Keep text selected after indenting/unindenting
keymap({ "n", "v", "o" }, "<", "<gv")
keymap({ "n", "v", "o" }, ">", ">gv")

-- Replay a series of commands recorded with `qq` by pressing `<leader>q` instead of `@q`
keymap({ "n", "o" }, "<leader>q", "@q", { desc = "[q] replay recorded commands in buffer q" })

-- Save file with <leader>w
keymap("n", "<leader>w", "<cmd>w!<cr>", { desc = "[w] Save file" })
