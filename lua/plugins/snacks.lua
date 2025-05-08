return {

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = false },
      image = {
        enabled = true,
        doc = { inline = false, float = false, max_width = 80, max_height = 40 },
        math = { latex = { font_size = "small" } },
      },
      indent = {
        enabled = true,
        animate = {
          enabled = false
        },
        indent = {
          only_scope = true
        },
        scope = {
          enabled = true, -- enable highlighting the current scope
          underline = true, -- underline the start of the scope
        },
        chunk = {
          -- when enabled, scopes will be rendered as chunks, except for the top-level scope which will be rendered as a scope.
          enabled = true,
        },
      },

      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },

    keys = {
      { "<A-w>", function() require("snacks").bufdelete() end, desc = "[Snacks] Delete buffer" },
      { "<leader>sgb", function() require("snacks").git.blame_line() end, desc = "[Snacks] Git blame line" },
      { "<leader>sgB", function() require("snacks").gitbrowse() end, desc = "[Snacks] Git browse" },
      { "<leader>si", function() require("snacks").image.hover() end, desc = "[Snacks] Display Image" },
    },

    init = function()
        local Snacks = require("snacks")
        vim.api.nvim_create_autocmd("User", {
          pattern = "VeryLazy",
          callback = function()
            -- Setup some globals for debugging (lazy-loaded)
            _G.dd = function(...)
              Snacks.debug.inspect(...)
            end
            _G.bt = function()
              Snacks.debug.backtrace()
            end
            vim.print = _G.dd -- Override print to use snacks for `:=` command

            vim.g.snacks_animate = false
            Snacks.toggle.new({
              id = "Animation",
              name = "Animation",
              get = function()
                return Snacks.animate.enabled()
              end,
              set = function(state)
                vim.g.snacks_animate = state
              end
            }):map("<leader>ta")

            -- Create some toggle mappings
            Snacks.toggle.dim():map("<leader>tD")

            Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
            Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
            Snacks.toggle.diagnostics():map("<leader>td")
            Snacks.toggle.line_number():map("<leader>tl")
            Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>tc")
            Snacks.toggle.treesitter():map("<leader>tT")
            Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>tb")
            Snacks.toggle.inlay_hints():map("<leader>th")
            Snacks.toggle.indent():map("<leader>tg")
            Snacks.toggle.dim():map("<leader>tD")
          end,
        })
      end,
  }
}
