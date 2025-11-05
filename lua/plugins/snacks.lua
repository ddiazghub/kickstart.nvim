local v = vim.version()
local version = string.format('  Neovim v%d.%d.%d  (  %s, %s)', v.major, v.minor, v.patch, _VERSION, jit and jit.version or 'Lua')

local header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]] .. version

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    animate = {
      enabled = true,
      duration = 10,
      fps = 60,
      easing = 'linear',
    },
    bigfile = {
      enabled = true,
      notify = true,
      size = 100 * 1024, -- Trigger at 100 KB
    },
    bufdelete = { enabled = true },
    dashboard = {
      enabled = true,

      preset = {
        header = header,
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = '󱞋 ', key = 'e', desc = 'Explorer', action = ':Oil' },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'M', desc = 'Mason', action = ':Mason' },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        { section = 'header' },
        {
          pane = 2,
          section = 'terminal',
          cmd = 'fish -c "fastfetch -c example21mod.jsonc"',
          height = 7,
          width = 100,
          padding = 1,
        },
        { section = 'keys', gap = 1, padding = 1 },
        { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        {
          pane = 2,
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = 'git status --short --branch --renames',
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = 'startup' },
      },
    },
    dim = {
      enabled = true,
      animate = { total = 30 },
    },
    gitbrowse = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true, style = 'fancy' },
    quickfile = { enabled = true },
    scratch = { enabled = true },
    scope = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        duration = { total = 70 },
        fps = 60,
        easing = 'linear',
      },
    },
    statuscolumn = { enabled = true },
    toggle = {
      which_key = true,
    },
    words = { enabled = true },
    zen = { enabled = true },
  },
  keys = require('config.keymaps').snacks.general,
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        -- Override print to use snacks for `:=` command
        if vim.fn.has 'nvim-0.11' == 1 then
          vim._print = function(_, ...)
            dd(...)
          end
        else
          vim.print = _G.dd
        end
        -- Create some toggle mappings
        require('config.keymaps').snacks.toggle()

        -- Create snacks autocmds
        require('config.autocmds').snacks()
      end,
    })
  end,
}
