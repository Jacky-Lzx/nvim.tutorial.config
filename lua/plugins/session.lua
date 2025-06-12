return {
  {
    "rmagatti/auto-session",
    lazy = false,

    keys = {
      { "<leader>ps", "<CMD>SessionRestore<CR>", desc = "[Auto Session] Restore session" },
      { "<leader>pS", "<CMD>Autosession search<CR>", desc = "[Auto Session] Search session" },
      { "<leader>pD", "<CMD>Autosession delete<CR>", desc = "[Auto Session] Delete session" },
    },

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      auto_restore = false,
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    },

    init = function()
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
  },
}
