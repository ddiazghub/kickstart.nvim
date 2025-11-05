---@module 'lazy'
---@type LazySpec
return {
  -- Autocompletion
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    build = 'cargo build --release',
    dependencies = { 'folke/lazydev.nvim', 'xzbdmw/colorful-menu.nvim', 'rafamadriz/friendly-snippets' },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap

        preset = 'default',
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 100 },
        ghost_text = { enabled = true },

        menu = {
          draw = {
            padding = { 0, 1 },
            treesitter = { 'lsp' },
            components = {
              kind_icon = {
                text = function(ctx)
                  return ' ' .. ctx.kind_icon .. ctx.icon_gap .. ' '
                end,
              },
              label = {
                kind_icon = {
                  highlight = function(ctx)
                    return { { group = ctx.kind_hl, priority = 20000 } }
                  end,
                },
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              },
              source_name = {
                text = function(ctx)
                  return '[' .. ctx.source_name .. ']'
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              },
            },
            columns = {
              {
                'label',
                'label_description',
                gap = 1,
              },
              { 'kind_icon', 'kind' },
              { 'source_name', gap = 1 },
            },
          },
        },

        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          snippets = {
            opts = {
              friendly_snippets = true,
            },
          },
        },
      },

      snippets = { preset = 'default' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
        sorts = {
          'exact',
          'score',
          'sort_text',
          'label',
        },
      },

      -- Shows a signature help window while you type arguments for a function
      signature = {
        enabled = true,
        window = {
          show_documentation = true,
          direction_priority = { 's', 'n' },
        },
        trigger = {
          enabled = true,
          show_on_accept = true,
        },
      },

      cmdline = {
        keymap = {
          preset = 'inherit',
          ['<Tab>'] = { 'select_next' },
          ['<S-Tab>'] = { 'select_prev' },
        },
        completion = {
          menu = {
            auto_show = true,
          },
          list = { selection = { auto_insert = true, preselect = false } },
        },
      },
    },
  },
  -- Autopairs
  {
    'saghen/blink.pairs',
    version = '*', -- (recommended) only required with prebuilt binaries
    build = 'cargo build --release',

    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
      mappings = {
        -- you can call require("blink.pairs.mappings").enable()
        -- and require("blink.pairs.mappings").disable()
        -- to enable/disable mappings at runtime
        enabled = true,
        cmdline = true,
        -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
        -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
        disabled_filetypes = {},
        -- see the defaults:
        -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L14
        pairs = {},
      },
      highlights = {
        enabled = true,
        -- requires require('vim._extui').enable({}), otherwise has no effect
        cmdline = true,
        groups = {
          'BlinkPairsOrange',
          'BlinkPairsPurple',
          'BlinkPairsBlue',
        },
        unmatched_group = 'BlinkPairsUnmatched',

        -- highlights matching pairs under the cursor
        matchparen = {
          enabled = true,
          -- known issue where typing won't update matchparen highlight, disabled by default
          cmdline = false,
          -- also include pairs not on top of the cursor, but surrounding the cursor
          include_surrounding = false,
          group = 'BlinkPairsMatchParen',
          priority = 250,
        },
      },
      debug = false,
    },
  },
}
