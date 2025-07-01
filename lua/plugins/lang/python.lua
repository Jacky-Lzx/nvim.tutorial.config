vim.lsp.enable("pyright")

local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "python" },
    },
    opts_extend = { "ensure_installed" },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts_extend = { "ensure_installed" },
    opts = { ensure_installed = { "ruff", "pyright" } },
  },

  -- formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
    },
  },

  -- linter
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        python = { "ruff" },
      },
    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp", -- Use this branch for the new version
    cmd = "VenvSelect",
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
      },
    },
    --  Call config for python files and load the cached venv automatically
    ft = "python",
    keys = { { "<leader>cv", "<CMD>VenvSelect<CR>", desc = "Select VirtualEnv", ft = "python" } },
  },
}

return M
