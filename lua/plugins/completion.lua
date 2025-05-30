return {
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
      -- 'rafamadriz/friendly-snippets'
      "nvim-tree/nvim-web-devicons",
      "onsails/lspkind.nvim",
      "fang2hou/blink-copilot",
      "folke/lazydev.nvim",
    },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      -- stylua: ignore
      keymap = {
        -- If the command/function returns false or nil, the next command/function will be run.
        preset = "none",
        ["<A-j>"] = { function(cmp) return cmp.select_next({ auto_insert = false }) end, "fallback", },
        ["<A-k>"] = { function(cmp) return cmp.select_prev({ auto_insert = false }) end, "fallback", },
        ["<C-n>"] = { function(cmp) return cmp.select_next({ auto_insert = false }) end, "fallback", },
        ["<C-p>"] = { function(cmp) return cmp.select_prev({ auto_insert = false }) end, "fallback", },

        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },

        ["<Tab>"] = { function(cmp) return cmp.accept() end, "fallback", },
        ["<CR>"] = { function(cmp) return cmp.accept() end, "fallback", },
        -- Close current completion and insert a newline
        ["<S-CR>"] = { function(cmp) cmp.hide() return false end, "fallback", },

        -- Show/Remove completion
        ["<A-/>"] = { function(cmp) if cmp.is_menu_visible() then return cmp.hide() else return cmp.show() end end, "fallback", },

        ["<A-n>"] = { function(cmp) cmp.show({ providers = {"buffer"} }) end, },
        ["<A-p>"] = { function(cmp) cmp.show({ providers = {"buffer"} }) end, },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "normal",
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = function()
          local success, node = pcall(vim.treesitter.get_node)
          if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            return { "buffer" }
          else
            return { "lazydev", "copilot", "lsp", "path", "snippets", "buffer" }
          end
        end,
        per_filetype = {
          codecompanion = { "codecompanion" },
        },

        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 95,
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
            opts = {
              kind_icon = "",
              kind_hl = "DevIconCopilot",
            },
          },
          path = {
            score_offset = 95,
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
          buffer = {
            score_offset = 20,
          },
          lsp = {
            -- Default
            -- Filter text items from the LSP provider, since we have the buffer provider for that
            transform_items = function(_, items)
              return vim.tbl_filter(function(item)
                return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
              end, items)
            end,
            score_offset = 60,
            fallbacks = { "buffer" },
          },
          -- Hide snippets after trigger character
          -- Trigger characters are defined by the sources. For example, for Lua, the trigger characters are ., ", '.
          snippets = {
            score_offset = 70,
            should_show_items = function(ctx)
              return ctx.trigger.initial_kind ~= "trigger_character"
            end,
            fallbacks = { "buffer" },
          },
          cmdline = {
            min_keyword_length = 2,
            -- Ignores cmdline completions when executing shell commands
            enabled = function()
              return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
            end,
          },
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        sorts = {
          "exact",
          -- defaults
          "score",
          "sort_text",
        },
      },

      completion = {
        -- NOTE: some LSPs may add auto brackets themselves anyway
        accept = { auto_brackets = { enabled = true } },
        list = { selection = { preselect = true, auto_insert = false } },
        menu = {
          border = "rounded",
          max_height = 20,
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if icon then
                    -- Do nothing
                  elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
                  end
                  return icon .. ctx.icon_gap
                end,
                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if hl then
                    -- Do nothing
                  elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          -- Delay before showing the documentation window
          auto_show_delay_ms = 200,
          window = {
            min_width = 10,
            max_width = 120,
            max_height = 20,
            border = "rounded",
            winblend = 0,
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
            -- Note that the gutter will be disabled when border ~= 'none'
            scrollbar = true,
            -- Which directions to show the documentation window,
            -- for each of the possible menu window directions,
            -- falling back to the next direction when there's not enough space
            direction_priority = {
              menu_north = { "e", "w", "n", "s" },
              menu_south = { "e", "w", "s", "n" },
            },
          },
        },
        -- Displays a preview of the selected item on the current line
        ghost_text = {
          enabled = true,
          -- Show the ghost text when an item has been selected
          show_with_selection = true,
          -- Show the ghost text when no item has been selected, defaulting to the first item
          show_without_selection = false,
          -- Show the ghost text when the menu is open
          show_with_menu = true,
          -- Show the ghost text when the menu is closed
          show_without_menu = true,
        },
      },

      signature = {
        enabled = true,
        window = {
          min_width = 1,
          max_width = 100,
          max_height = 10,
          border = "single", -- Defaults to `vim.o.winborder` on nvim 0.11+ or 'padded' when not defined/<=0.10
          winblend = 0,
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
          scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
          -- Which directions to show the window,
          -- falling back to the next direction when there's not enough space,
          -- or another window is in the way
          direction_priority = { "n" },
          -- Disable if you run into performance issues
          treesitter_highlighting = true,
          show_documentation = true,
        },
      },

      cmdline = {
        completion = {
          menu = {
            auto_show = true,
          },
        },
        -- stylua: ignore
        keymap = {
          preset = "none",
          ["<A-j>"] = { function(cmp) return cmp.select_next({ auto_insert = false }) end, "fallback", },
          ["<A-k>"] = { function(cmp) return cmp.select_prev({ auto_insert = false }) end, "fallback", },
          ["<C-p>"] = { function(cmp) return cmp.select_prev({ auto_insert = false }) end, "fallback", },
          ["<C-n>"] = { function(cmp) return cmp.select_next({ auto_insert = false }) end, "fallback", },
          ["<Tab>"] = { function(cmp) return cmp.accept() end, "fallback", },
          ["<CR>"] = { function(cmp) if vim.fn.getcmdtype() == ":" then return cmp.accept_and_enter() end return false end, "fallback", },
          ["<A-/>"] = { function(cmp) if cmp.is_menu_visible() then return cmp.hide() else return cmp.show() end end, "fallback", },
        },
      },
    },

    opts_extend = { "sources.default" },
  },
}
