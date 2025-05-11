-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number=true
vim.wo.cursorline = true
-- Display tabs and trailing spaces
vim.opt.list = true
vim.opt.listchars = { tab = ">-", trail = "-" }
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 10
vim.opt.startofline = false

vim.opt.conceallevel = 2

vim.wo.wrap = false

-- Tab related options
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy") -- Import `./lua/config/lazy.lua`

require("keymapping")

-- Snacks profiler
if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  })
end
