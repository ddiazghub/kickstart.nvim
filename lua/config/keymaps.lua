-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
--
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Comments ]]
-- TODO: Merge builtin comment functionality with motions

-- [[ Emacs Motions ]]
vim.keymap.set({ 'i', 'c' }, '<C-a>', '<Home>', { desc = 'Emacs: Beginning of line' })
vim.keymap.set({ 'i', 'c' }, '<C-e>', '<End>', { desc = 'Emacs: End of line' })
vim.keymap.set({ 'i', 'c' }, '<C-k>', '<C-o>D', { desc = 'Emacs: Kill to end of line' })
vim.keymap.set({ 'i', 'c' }, '<C-u>', '<C-o>d0', { desc = 'Emacs: Kill to beginning of line' })

-- [[ Explorer ]]
vim.keymap.set('n', '<leader>e', function()
  require('oil').toggle_float()
end, { desc = '[Explorer]: Toggle' })
--
-- -- Toggle showing dotfiles in Mini.files
-- local show_dotfiles = true
-- local filter_show = function(fs_entry)
--   return true
-- end
-- local filter_hide = function(fs_entry)
--   return not vim.startswith(fs_entry.name, '.')
-- end
--
-- local toggle_dotfiles = function()
--   show_dotfiles = not show_dotfiles
--   local new_filter = show_dotfiles and filter_show or filter_hide
--   MiniFiles.refresh { content = { filter = new_filter } }
-- end
--
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'MiniFilesBufferCreate',
--   callback = function(args)
--     local buf_id = args.data.buf_id
--     -- Tweak left-hand side of mapping to your liking
--     vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id, desc = 'Explorer: Toggle dotfiles' })
--   end,
-- })

vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'grn')

-- [[ Lsp keymaps ]]
---@param buffer integer
---@param client vim.lsp.Client?
local function lsp(buffer, client)
  local Snacks = require 'snacks'

  vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { buffer = buffer, desc = '[L]SP: [R]ename' })
  vim.keymap.set({ 'n', 'x' }, '<leader>la', vim.lsp.buf.code_action, { buffer = buffer, desc = '[L]SP: Code [A]ction' })
  vim.keymap.set('n', 'gd', Snacks.picker.lsp_definitions, { buffer = buffer, desc = 'LSP: [G]oto [D]efinition' }) --  To jump back, press <C-t>.
  vim.keymap.set('n', 'gr', Snacks.picker.lsp_references, { buffer = buffer, desc = 'LSP: [G]oto [R]eferences' })
  vim.keymap.set('n', 'gi', Snacks.picker.lsp_implementations, { buffer = buffer, desc = 'LSP: [G]oto [I]mplementation' })
  vim.keymap.set('n', 'gD', Snacks.picker.lsp_declarations, { buffer = buffer, desc = 'LSP: [G]oto [D]eclaration' })
  vim.keymap.set('n', 'gt', Snacks.picker.lsp_type_definitions, { buffer = buffer, desc = 'LSP: [G]oto [T]ype Definition' })
  vim.keymap.set('n', '<leader>ls', Snacks.picker.lsp_symbols, { buffer = buffer, desc = '[L]SP: Document [S]ymbols' })
  vim.keymap.set('n', '<leader>lS', Snacks.picker.lsp_workspace_symbols, { buffer = buffer, desc = '[L]SP: Open Workspace Symbols' })
  vim.keymap.set('n', '<leader>lc', Snacks.picker.lsp_incoming_calls, { buffer = buffer, desc = '[L]SP: [C]alls Incoming' })
  vim.keymap.set('n', '<leader>lC', Snacks.picker.lsp_outgoing_calls, { buffer = buffer, desc = '[L]SP: [C]alls Outgoing' })
  vim.keymap.set('n', '<leader>ld', Snacks.picker.diagnostics, { buffer = buffer, desc = '[L]SP: [D]iagnostics' })
  vim.keymap.set('n', '<leader>lD', Snacks.picker.diagnostics, { buffer = buffer, desc = '[L]SP: Buffer [D]iagnostics' })

  -- Toggle inlay hints if the LSP server provides them
  -- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, buffer) then
  --   vim.keymap.set('n', '<leader>lth', function()
  --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buffer })
  --   end, { buffer = buffer, desc = '[L]SP: [T]oggle Inlay [H]ints' })
  -- end
end

-- [[ Keymaps related to the snacks.nvim plugin ]]
local snacks = {
  ---@type { [1]: string, [2]: function, desc: string }[]
  general = {
    -- find
    {
      '<leader><space>',
      function()
        Snacks.picker.smart()
      end,
      desc = 'Find: Smart Find',
    },
    {
      '<leader>ff',
      function()
        Snacks.picker.files()
      end,
      desc = '[F]ind: [F]iles',
    },
    {
      '<leader>fb',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[F]ind: [B]uffers',
    },
    {
      '<leader>,',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[F]ind: [B]uffers (Shortcut)',
    },
    {
      '<leader>fc',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[F]ind: Neovim [C]onfig',
    },
    {
      '<leader>f,',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[F]ind: Neovim [C]onfig',
    },
    {
      '<leader>fg',
      function()
        Snacks.picker.git_files()
      end,
      desc = '[F]ind: [G]it Files',
    },
    {
      '<leader>fp',
      function()
        Snacks.picker.projects()
      end,
      desc = '[F]ind: [P]rojects',
    },
    {
      '<leader>fr',
      function()
        Snacks.picker.recent()
      end,
      desc = '[F]ind: [R]ecent',
    },
    -- git
    {
      '<leader>gg',
      function()
        Snacks.lazygit.open()
      end,
      desc = '[G]it: Lazy[G]it',
    },
    {
      '<leader>gb',
      function()
        Snacks.picker.git_branches()
      end,
      desc = '[G]it: [B]ranches',
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = '[G]it: [B]rowse',
      mode = { 'n', 'v' },
    },
    {
      '<leader>gl',
      function()
        Snacks.picker.git_log()
      end,
      desc = '[G]it: [L]og',
    },
    {
      '<leader>gL',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = '[G]it: [L]og for current line',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = '[G]it: [S]tatus',
    },
    {
      '<leader>gS',
      function()
        Snacks.picker.git_stash()
      end,
      desc = '[G]it: [S]tash',
    },
    {
      '<leader>gd',
      function()
        Snacks.picker.git_diff()
      end,
      desc = '[G]it: [D]iff (Hunks)',
    },
    {
      '<leader>gf',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = '[G]it: Log [F]ile',
    },
    -- Github Integration
    {
      '<leader>gi',
      function()
        Snacks.picker.gh_issue()
      end,
      desc = '[G]it: GitHub [I]ssues (open)',
    },
    {
      '<leader>gI',
      function()
        Snacks.picker.gh_issue { state = 'all' }
      end,
      desc = '[G]it: GitHub [I]ssues (all)',
    },
    {
      '<leader>gp',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = '[G]it: GitHub [P]ull Requests (open)',
    },
    {
      '<leader>gP',
      function()
        Snacks.picker.gh_pr { state = 'all' }
      end,
      desc = '[G]it: GitHub [P]ull Requests (all)',
    },
    -- Search Text
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Text [S]earch: [B]uffer Lines',
    },
    {
      '<leader>?',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Text [S]earch: [B]uffer Lines (Shortcut)',
    },
    {
      '<leader>sB',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = 'Text [S]earch: Grep in Open [B]uffers',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Text [S]earch: [G]rep',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Text [S]earch: [G]rep (Shortcut)',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Text [S]earch: Visual selection or current [W]ord',
      mode = { 'n', 'x' },
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.search_history()
      end,
      desc = 'Text [S]earch: Search History (/)',
    },
    -- search
    {
      '<leader>sr',
      function()
        Snacks.picker.registers()
      end,
      desc = '[S]earch: [R]egisters',
    },
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = '[S]earch: Registers',
    },
    {
      '<leader>sa',
      function()
        Snacks.picker.autocmds()
      end,
      desc = '[S]earch: [A]utocmds',
    },
    {
      '<leader>sn',
      function()
        Snacks.picker.notifications()
      end,
      desc = '[S]earch: [N]otification History',
    },
    {
      '<leader>sc',
      function()
        Snacks.picker.commands()
      end,
      desc = '[S]earch: [C]ommands',
    },
    {
      '<leader>:',
      function()
        Snacks.picker.commands()
      end,
      desc = '[S]earch: [C]ommands (Shortcut)',
    },
    {
      '<leader>sC',
      function()
        Snacks.picker.command_history()
      end,
      desc = '[S]earch: [C]ommand History',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = '[S]earch: [H]elp Pages',
    },
    {
      '<leader>sH',
      function()
        Snacks.picker.highlights()
      end,
      desc = '[S]earch: [H]ighlight Groups',
    },
    {
      '<leader>si',
      function()
        Snacks.picker.icons()
      end,
      desc = '[S]earch: [I]cons',
    },
    {
      '<leader>sj',
      function()
        Snacks.picker.jumps()
      end,
      desc = '[S]earch: [J]umps',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[S]earch: [K]eymaps',
    },
    {
      '<leader>sl',
      function()
        Snacks.picker.loclist()
      end,
      desc = '[S]earch: [L]ocation List',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = '[S]earch: [M]arks',
    },
    {
      '<leader>sM',
      function()
        Snacks.picker.man()
      end,
      desc = '[S]earch: [M]an Pages',
    },
    {
      '<leader>sp',
      function()
        Snacks.picker.lazy()
      end,
      desc = '[S]earch: for [P]lugin Spec',
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = '[S]earch: [Q]uickfix List',
    },
    {
      '<leader>sR',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch: [R]esume',
    },
    {
      '<leader>su',
      function()
        Snacks.picker.undo()
      end,
      desc = '[S]earch: [U]ndo History',
    },
    {
      '<leader>st',
      function()
        Snacks.picker.todo_comments()
      end,
      desc = '[S]earch: [T]odo Comments',
    },
    {
      '<leader>sT',
      function()
        Snacks.picker.colorschemes()
      end,
      desc = '[S]earch: [T]hemes',
    },
    -- Other
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Scratch Buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
    {
      '<leader>nh',
      function()
        Snacks.notifier.show_history()
      end,
      desc = '[N]otification: [H]istory',
    },
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = '[B]uffer: [D]elete',
    },
    {
      '<leader>cR',
      function()
        Snacks.rename.rename_file()
      end,
      desc = 'Rename File',
    },
    {
      '<leader>nd',
      function()
        Snacks.notifier.hide()
      end,
      desc = '[N]otification: [D]ismiss All',
    },
    {
      '<c-/>',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle Terminal',
    },
    {
      '<c-_>',
      function()
        Snacks.terminal()
      end,
      desc = 'which_key_ignore',
    },
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Jump to Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Jump to Previous Reference',
      mode = { 'n', 't' },
    },
    {
      '<leader>N',
      desc = '[N]eovim: News',
      function()
        Snacks.win {
          file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
          width = 0.318,
          height = 0.8,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'yes',
            statuscolumn = ' ',
            conceallevel = 3,
          },
          border = 'rounded',
        }
      end,
    },
    -- Not working
    -- {
    --   '<leader>pp',
    --   desc = '[P]rofiler: Toggle',
    --   function()
    --     Snacks.toggle.profiler()
    --   end,
    -- },
    -- {
    --   '<leader>ph',
    --   desc = '[P]rofiler: [H]ighlights',
    --   function()
    --     Snacks.toggle.profiler_highlights()
    --   end,
    -- },
    -- {
    --   '<leader>ps',
    --   function()
    --     Snacks.profiler.scratch()
    --   end,
    --   desc = '[P]rofiler: [S]cratch Bufer',
    -- },
  },
  toggle = function()
    Snacks.toggle.option('spell', { name = '[S]pelling' }):map '<leader>ts'
    Snacks.toggle.option('wrap', { name = '[W]rap' }):map '<leader>tw'
    Snacks.toggle.option('relativenumber', { name = 'Relative [N]umber' }):map '<leader>tN'
    Snacks.toggle.line_number():map '<leader>tn'
    Snacks.toggle.diagnostics():map '<leader>td'
    Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>tc'
    Snacks.toggle.treesitter():map '<leader>tt'
    Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark [B]ackground' }):map '<leader>tb'
    Snacks.toggle.inlay_hints():map '<leader>th'
    Snacks.toggle.indent():map '<leader>ti'
    Snacks.toggle.zen():map '<leader>tz'
    Snacks.toggle.zoom():map '<leader>tZ'
    Snacks.toggle.dim():map '<leader>tD'
    Snacks.toggle.animate():map '<leader>ta'
    Snacks.toggle.profiler():map '<leader>tp'
    Snacks.toggle.profiler_highlights():map '<leader>tH'
    Snacks.toggle.scroll():map '<leader>tS'
    Snacks.toggle.words():map '<leader>tW'
  end,
}

return {
  lsp = lsp,
  snacks = snacks,
}
