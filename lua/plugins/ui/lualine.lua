---@module 'lazy'
---@type LazySpec
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Eviline config for lualine
    -- Author: shadmansaleh
    -- Credit: glepnir
    local lualine = require 'lualine'

    -- Color table for highlights
    local colors = {
      bg = '#202328',
      fg = '#bbc2cf',
      darkgray = '#343434',
      gray = '#888888',
      yellow = '#ECBE7B',
      cyan = '#008080',
      darkblue = '#081633',
      green = '#98be65',
      orange = '#FF8800',
      violet = '#a9a1e1',
      magenta = '#c678dd',
      blue = '#51afef',
      red = '#ec5f67',
    }

    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand '%:t') ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand '%:p:h'
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
    }

    -- Config
    local config = {
      options = {
        -- Disable sections and component separators
        component_separators = '',
        section_separators = '',
        theme = {
          -- We are going to use lualine_c an lualine_x as left and
          -- right section. Both are highlighted by c theme .  So we
          -- are just setting default looks o statusline
          normal = { c = { fg = colors.fg, bg = colors.bg } },
          inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    }

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x at right section
    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    ins_left {
      function()
        return ''
      end,
      color = function()
        return { fg = mode_color[vim.fn.mode()] }
      end, -- Sets highlighting of component
      padding = { left = 0, right = 0 }, -- We don't need space before this
    }

    ins_left {
      -- mode component
      function()
        local mode_text = {
          n = 'NORMAL',
          i = 'INSERT',
          v = 'VISUAL',
          [''] = 'V-BLOCK',
          V = 'V-LINE',
          c = 'COMMAND',
          no = 'NORMAL',
          s = 'SELECT',
          S = 'S-LINE',
          [''] = 'S-BLOCK',
          -- ic = colors.yellow,
          R = 'REPLACE',
          Rv = 'REPLACE',
          -- cv = colors.red,
          -- ce = colors.red,
          r = 'REPLACE',
          -- rm = colors.cyan,
          -- ['r?'] = colors.cyan,
          -- ['!'] = colors.red,
          t = 'TERMINAL',
        }

        return mode_text[vim.fn.mode()] or 'NEOVIM'
      end,
      color = function()
        return { bg = mode_color[vim.fn.mode()], fg = colors.bg, gui = 'bold' }
      end,
      padding = { left = 1, right = 1 },
    }

    ins_left {
      function()
        return ''
      end,
      color = function()
        return { fg = mode_color[vim.fn.mode()], bg = colors.darkgray }
      end,
      padding = { left = 0, right = 0 },
    }

    ins_left {
      'filename',
      cond = conditions.buffer_not_empty,
      color = { bg = colors.darkgray, gui = 'bold' },
      file_status = true,
      fmt = function(str)
        local icon, iconhl = require('nvim-web-devicons').get_icon(str)
        local fg = vim.api.nvim_get_hl_by_name(iconhl, true).foreground
        local custom_hl = 'MyFileComponentHL'
        vim.cmd(string.format('highlight %s guifg=%s guibg=%s gui=bold', custom_hl, string.format('#%06x', fg), colors.darkgray))

        if icon then
          -- %#HL# … %* sets highlight for this segment
          return '%#' .. custom_hl .. '#' .. icon .. ' ' .. str .. '%*'
        else
          return '%#' .. custom_hl .. '#' .. str .. '%*'
        end
      end,
    }

    ins_left {
      function()
        return ''
      end,
      color = { fg = colors.darkgray, bg = colors.blue },
      padding = { left = 0, right = 0 },
    }

    ins_left {
      -- filesize component
      'filesize',
      cond = conditions.buffer_not_empty,
      color = { bg = colors.blue, fg = colors.bg, gui = 'bold' },
    }

    ins_left { 'location', color = { fg = colors.bg, bg = colors.blue, gui = 'bold' } }

    -- interpolate between two hex colors based on t in [0,1]
    local function lerp_color(color1, color2, t)
      local function hex_to_rgb(hex)
        hex = hex:gsub('#', '')
        return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
      end

      local function rgb_to_hex(r, g, b)
        return string.format('#%02x%02x%02x', r, g, b)
      end

      local r1, g1, b1 = hex_to_rgb(color1)
      local r2, g2, b2 = hex_to_rgb(color2)

      local r = math.floor(r1 + (r2 - r1) * t + 0.5)
      local g = math.floor(g1 + (g2 - g1) * t + 0.5)
      local b = math.floor(b1 + (b2 - b1) * t + 0.5)

      return rgb_to_hex(r, g, b)
    end

    local function get_cursor_gradient()
      local line = vim.fn.line '.' -- current line
      local total = vim.fn.line '$' -- total lines
      return (line - 1) / (math.max(total - 1, 1)) -- t in [0,1]
    end

    local function gradient_fg(color1, color2)
      return lerp_color(color1, color2, get_cursor_gradient())
    end

    -- Left 
    ins_left {
      function()
        return ''
      end,
      color = function()
        return { fg = colors.blue, bg = gradient_fg(colors.green, colors.red), gui = 'bold' }
      end,
      padding = { left = 0, right = 0 },
    }

    -- progress
    ins_left {
      'progress',
      color = function()
        return { fg = colors.bg, bg = gradient_fg(colors.green, colors.red), gui = 'bold' }
      end,
    }

    -- Right 
    ins_left {
      function()
        return ''
      end,
      color = function()
        return { bg = colors.bg, fg = gradient_fg(colors.green, colors.red), gui = 'bold' }
      end,
      padding = { left = 0, right = 0 },
    }

    ins_left {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      symbols = { error = ' ', warn = ' ', info = ' ' },
      diagnostics_color = {
        error = { fg = colors.red },
        warn = { fg = colors.yellow },
        info = { fg = colors.cyan },
      },
    }

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    ins_left {
      function()
        return '%='
      end,
    }

    ins_left {
      -- Lsp server name .
      function()
        local msg = 'No Active Lsp'
        local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
          return msg
        end
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
          end
        end
        return msg
      end,
      icon = ' LSP:',
      color = { fg = '#ffffff', gui = 'bold' },
    }

    -- Add components to right sections
    ins_right {
      'o:encoding', -- option component same as &encoding in viml
      fmt = string.upper, -- I'm not sure why it's upper case either ;)
      cond = conditions.hide_in_width,
      color = { fg = colors.green, gui = 'bold' },
    }

    ins_right {
      'fileformat',
      fmt = string.upper,
      icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
      color = { fg = colors.green, gui = 'bold' },
    }

    ins_right {
      'branch',
      icon = '',
      color = { fg = colors.violet, gui = 'bold' },
    }

    ins_right {
      'diff',
      -- Is it me or the symbol for modified us really weird
      symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
      diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.orange },
        removed = { fg = colors.red },
      },
      cond = conditions.hide_in_width,
    }

    ins_right {
      function()
        return '▊'
      end,
      color = { fg = colors.blue },
      padding = { left = 1 },
    }

    -- Now don't forget to initialize lualine
    lualine.setup(config)
  end,
}
