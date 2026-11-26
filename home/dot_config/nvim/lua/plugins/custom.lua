-- Every spec file under the "plugins" directory will be loaded automatically
-- by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins

return {
  -- CATPPUCCIN:
  -- Override the default TokyoNight colorscheme with Catppuccin
  -- https://github.com/catppuccin/nvim
  { "catppuccin/nvim", name = "catppuccin", priority = 100 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-macchiato",
      integrations = { blink_cmp = true },
    },
  },

  -- CONFORM.NVIM:
  -- Add additional formatters by filetype. To see available formatters, run
  -- `:h conform-formatters`
  -- {
  --   "stevearc/conform.nvim",
  --   opts = {
  --     formatters_by_ft = {
  --       -- The following formatters are already configured by LazyVim:
  --       -- lua = { "stylua" },
  --       -- fish = { "fish_indent" },
  --       -- sh = { "shfmt" },
  --       -- python = { "ruff_organize_imports", lsp_format = "first" },
  --       python = { "ruff" },
  --       latex = { "tex-fmt" },
  --       r = { "air" },
  --       c = { "cmakelang" },
  --       cpp = { "cmakelang" },
  --       cmake = { "cmakelang" },
  --       javascript = { "prettierd" },
  --       typescript = { "prettierd" },
  --       javascriptreact = { "prettierd" },
  --       typescriptreact = { "prettierd" },
  --       json = { "prettierd" },
  --       markdown = { "prettierd" },
  --       css = { "prettierd" },
  --       scss = { "prettierd" },
  --       html = { "prettierd" },
  --       yaml = { "prettierd" },
  --       less = { "prettierd" },
  --     },
  --   },
  -- },

  -- NVIM-LINT:
  -- Add additional linters by filetype
  -- {
  --   "mfussenegger/nvim-lint",
  --   event = "LazyFile",
  --   opts = {
  --     events = { "BufWritePost", "BufReadPost", "InsertLeave" },
  --     linters_by_ft = {
  --       lua = { "selene" },
  --       fish = { "fish" },
  --       sh = { "shellcheck" },
  --       bash = { "shellcheck" },
  --       c = { "cmakelint" },
  --       cpp = { "cmakelint" },
  --       cmake = { "cmakelint" },
  --       -- python = { "ruff" },
  --       javascript = { "eslint" },
  --       typescript = { "eslint" },
  --       javascriptreact = { "eslint" },
  --       typescriptreact = { "eslint" },
  --       css = { "eslint" },
  --       scss = { "eslint" },
  --       json = { "jsonlint" },
  --       yaml = { "yamllint" },
  --       html = { "htmlhint" },
  --       markdown = { "markdownlint" },
  --       sql = { "sqlfluff" },
  --     },
  --   },
  -- },

  -- MINI.SURROUND:
  -- Change mappings for adding surround-quotes to highlighted text.
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "S", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
    init = function()
      local custom_surroundings = {
        markdown = {
          ["b"] = { -- Surround for bold
            input = { "%*%*().-()%*%*" },
            output = { left = "**", right = "**" },
          },
          ["i"] = { -- Surround for italics
            input = { "%_().-()%_" },
            output = { left = "_", right = "_" },
          },
          ["m"] = { -- Surround for monospace
            input = { "%`().-()%`" },
            output = { left = "`", right = "`" },
          },
          ["l"] = { -- Surround for hyperlink
            input = { "%[().-()%]%([^)]+%)" },
            output = function()
              local href = require("mini.surround").user_input("Href")
              return {
                left = "[",
                right = "](" .. href .. ")",
              }
            end,
          },
          ["r"] = { -- Surround for label
            input = { "%[().-()%]%[[^)]+%]" },
            output = function()
              local label = require("mini.surround").user_input("Label")
              return {
                left = "[",
                right = "][" .. label .. "]",
              }
            end,
          },
        },
        tex = {
          ["b"] = { -- Surround for \textbf
            input = { "%\\%t%e%x%t%b%f%{().-()%}" },
            output = { left = "\\textbf{", right = "}" },
          },
          ["e"] = { -- Surround for \emph
            input = { "%\\%e%m%p%h%{().-()%}" },
            output = { left = "\\emph{", right = "}" },
          },
          ["u"] = { -- Surround for \underline
            input = { "%\\%u%n%d%e%r%l%i%n%e%{().-()%}" },
            output = { left = "\\underline{", right = "}" },
          },
        },
      }
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dotfiles-mini_surround", {}),
        pattern = vim.fn.join(vim.tbl_keys(custom_surroundings), ","),
        callback = function()
          local ft = vim.opt.filetype:get()
          vim.b.minisurround_config = {
            custom_surroundings = custom_surroundings[ft],
          }
        end,
      })
    end,
  },

  -- FLASH.NVIM:
  -- disable the flash treesitter keymap in favor of minisurround "S"
  {
    "folke/flash.nvim",
    keys = {
      { "S", mode = { "n", "o", "x" }, false },
    },
  },

  -- SNACKS.NVIM:
  -- disable <C-/> for toggling a terminal. use <leader>ft / <leader>fT to open
  -- and <ESC><ESC>q to quit
  {
    "folke/snacks.nvim",
    keys = {
      { "<C-/>", mode = { "n", "v" }, false },
    },
  },

  -- COMMENT.NVIM:
  -- Use <C-/> to toggle line-level comments in normal and visual mode
  {
    "numToStr/Comment.nvim",
    opts = {
      toggler = { line = "<c-/>" },
      opleader = { line = "<c-/>" },
    },
  },

  -- VIMTEX:
  -- Compile document with `<leader>b`, disable unicode characters in editor
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    init = function()
      if vim.fn.has("unix") == 1 then
        vim.gvimtex_view_general_viewer = "/Applications/Skim.app/Contents/SharedSupport/displayline"
        vim.g.vimtex_view_general_options = "-r @line @pdf @tex"
        vim.g.vimtex_view_method = "skim"
        vim.g.vimtex_view_skim_sync = 1
        vim.g.vimtex_view_skim_activate = 1
      end

      -- Compile and view LaTeX documents with `<leader>b`
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "tex" },
        callback = function()
          vim.cmd([[ nmap <buffer> <leader>b :w!<cr>:VimtexCompileSS<cr>:VimtexView<cr> ]])
        end,
      })

      vim.g.tex_flavor = "latex"

      -- The quickfix window is never opened/closed automatically.
      vim.g.vimtex_quickfix_mode = 0

      -- ignore the `can't use callbacks without + clientserver` error
      vim.g.vimtex_disable_version_warning = 2

      -- disable/enable VimTeX indentation.
      vim.g.vimtex_indent_enabled = 1
      vim.g.vimtex_fold_enabled = 0

      -- Don't open QuickFix menu for warning messages if no errors are present
      vim.g.vimtex_quickfix_open_on_warning = 0

      -- Ignore unhelpful warning messages
      vim.g.vimtex_quickfix_ignore_filters = { "Underfull \\hbox", "Overfull \\hbox" }

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
    end,
  },

  -- BLINK-CMP
  -- Use <tab> for accepting autocomplete suggestion, navigate options with <C-j>, <C-k>
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      },
    },
  },
  {
    {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
        opts.servers.ruff = {
          init_options = {
            settings = {
              lineLength = 110,
            },
          },
        }

        opts.servers.basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                ignore = { "*" },
              },
              disableOrganizeImports = true,
            },
          },
        }
      end,
    },
  },
  -- NVIM.LSPCONFIG
  -- Disable ruff linter
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       ruff = {
  --         init_options = {
  --           settings = {
  --             lint = {
  --               enable = false,
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}
