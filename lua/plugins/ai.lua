return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VeryLazy",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.diff",
      "j-hui/fidget.nvim",
    },

    init = function()
      require("utils.codecompanion_fidget_spinner"):init()
    end,

    -- stylua: ignore
    keys = {
      {"<leader>cca", "<CMD>CodeCompanionActions<CR>",     mode = {"n", "v"}, noremap = true, silent = true, desc = "CodeCompanion actions"      },
      {"<leader>cci", "<CMD>CodeCompanion<CR>",            mode = {"n", "v"}, noremap = true, silent = true, desc = "CodeCompanion inline"       },
      {"<leader>ccc", "<CMD>CodeCompanionChat Toggle<CR>", mode = {"n", "v"}, noremap = true, silent = true, desc = "CodeCompanion chat (toggle)"},
      {"<leader>ccp", "<CMD>CodeCompanionChat Add<CR>",    mode = {"v"}     , noremap = true, silent = true, desc = "CodeCompanion chat add code"},
    },

    opts = {
      display = {
        diff = {
          enabled = true,
          provider = "mini_diff",
        },
      },

      strategies = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
      },

      opts = {
        language = "English", -- "English"|"Chinese"
      },
    },
  },
}
