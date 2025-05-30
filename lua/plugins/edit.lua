return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
    },
  },

  -- {
  --   "cappyzawa/trim.nvim",
  --   event = "BufWritePre",
  --   opts = {},
  -- },

  {
    "mbbill/undotree",
    keys = {
      { "<leader>ut", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo-tree" },
    },
    init = function()
      vim.cmd([[
      if has("persistent_undo")
         let target_path = expand('~/.undodir')

          " create the directory and any parent directories if the location does not exist.
          if !isdirectory(target_path)
              call mkdir(target_path, "p", 0700)
          endif

          let &undodir=target_path
          set undofile
      endif
      ]])
    end,
  },

  {
    "numToStr/Comment.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>/", function() require("Comment.api").toggle.linewise.current() end,                 mode = "n", desc = "[Comment] Comment current line", },
      { "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", mode = "v", desc = "Comment current line",           },
      -- control + / keymappings
      { "<C-_>",     function() require("Comment.api").toggle.linewise.current() end,                 mode = "n", desc = "[Comment] Comment current line", },
      { "<C-_>",     "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", mode = "v", desc = "Comment current line",           },
    },
    config = true,
  },

  {
    "ibhagwan/smartyank.nvim",
    event = { "BufWinEnter" },
    opts = {
      highlight = {
        timeout = 500, -- timeout for clearing the highlight
      },
      clipboard = {
        enabled = true,
      },
      osc52 = {
        silent = true, -- true to disable the "n chars copied" echo
      },
    },
  },

  {
    "folke/flash.nvim",
    event = "BufReadPost",
    opts = {
      label = {
        rainbow = {
          enabled = true,
          shade = 1,
        },
      },
      modes = {
        char = {
          enabled = false,
        },
      },
    },
    keys = {
      -- stylua: ignore
      { "<leader>f", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "[Flash] Jump"              },
      -- stylua: ignore
      { "<leader>F", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "[Flash] Treesitter"        },
      -- stylua: ignore
      { "<leader>F", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "[Flash] Treesitter Search" },
      -- stylua: ignore
      { "<c-f>",     mode = { "c" },           function() require("flash").toggle() end,            desc = "[Flash] Toggle Search"     },
      {
        "<leader>j",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 }, matches = false },
            jump = { pos = "end" },
            pattern = "^\\s*\\S\\?", -- match non-whitespace at start plus any character (ignores empty lines)
          })
        end,
        desc = "[Flash] Line jump",
      },
      {
        "<leader>k",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 }, matches = false },
            jump = { pos = "end" },
            pattern = "^\\s*\\S\\?", -- match non-whitespace at start plus any character (ignores empty lines)
          })
        end,
        desc = "[Flash] Line jump",
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>st", function() require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME", "BUG", "FIXIT", "HACK", "WARN", "ISSUE"  } }) end, desc = "[TODO] Pick todos (without NOTE)", },
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>sT", function() require("snacks").picker.todo_comments() end, desc = "[TODO] Pick todos (with NOTE)", },
    },
    config = true,
  },

  {
    "echasnovski/mini.surround",
    version = "*",
    event = "BufReadPost",
    config = true,
    keys = {
      -- Disable the vanilla `s` keybinding
      { "s", "<NOP>", mode = { "n", "x", "o" } },
    },
  },

  {
    -- Extend `a`/`i` textobjects
    "echasnovski/mini.ai",
    version = "*",
    event = "BufReadPost",
    config = true,
  },

  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "BufReadPost",
    keys = {
      -- Append/insert for each line of visual selections. Similar to block selection insertion.
      {
        "mI",
        function()
          require("multicursor-nvim").insertVisual()
        end,
        mode = "x",
        desc = "Insert cursors at visual selection",
      },
      {
        "mA",
        function()
          require("multicursor-nvim").appendVisual()
        end,
        mode = "x",
        desc = "Append cursors at visual selection",
      },
    },
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      -- Mappings defined in a keymap layer only apply when there are multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          mc.clearCursors()
        end)
      end)
    end,
  },

  { "wakatime/vim-wakatime", lazy = false },
}
