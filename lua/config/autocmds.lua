-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
--
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Format on save
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('lsp-format', {}),
  callback = function(ev)
    local clients = vim.lsp.get_clients { bufnr = ev.buf }
    for _, client in ipairs(clients) do
      if client:supports_method ('textDocument/formatting', ev.buf) then
        vim.lsp.buf.format { bufnr = ev.buf }
        return
      end
    end
  end,
})

-- Apply my highlights when changing colorscheme
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Apply custom highlight groups when changing colorscheme',
  group = vim.api.nvim_create_augroup('colorscheme-highlights', { clear = true }),
  callback = function()
    local highlights = require 'config.highlights'
    highlights.gitsigns()
  end,
})

-- This function gets run when an LSP attaches to a particular buffer.
--  That is to say, every time a new file is opened that is associated with
--  an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--  function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP related keymaps and autocmds on LspAttach',
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Configure keymaps
    require('config.keymaps').lsp(event.buf, client)

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end
  end,
})

-- LSP progress notification
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params
    .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= 'table' then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ('[%3d%%] %s%s'):format(
            value.kind == 'end' and 100 or value.percentage or 100,
            value.title or '',
            value.message and (' **%s**'):format(value.message) or ''
          ),
          done = value.kind == 'end',
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    vim.notify(table.concat(msg, '\n'), 'info', {
      id = 'lsp_progress',
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and ' ' or
        spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Add keymaps to oil.nvim buffers',
  group = vim.api.nvim_create_augroup('oil-filetype', { clear = true }),
  pattern = 'oil',
  callback = function(args)
    local oil = require 'oil'
    vim.keymap.set('n', 'q', oil.close, { buffer = args.buf, desc = 'Close Oil Buffer' })
    vim.keymap.set('n', '<esc>', oil.close, { buffer = args.buf, desc = 'Close Oil Buffer' })
  end,
})

-- If no other listed buffers remain, open the dashboard
local snacks = function()
  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = vim.api.nvim_create_augroup('dashboard', { clear = true }),
    callback = function(args)
      local buffers = vim.tbl_filter(function()
        return not ((vim.bo[args.buf].buftype or '') == '' and (vim.api.nvim_buf_get_name(args.buf) or '') == '' and (vim.bo[args.buf].filetype or '') == '')
      end, vim.api.nvim_list_bufs())
      ---@module 'snacks'

      if #buffers == 0 then
        Snacks.dashboard()
      end
    end,
  })
end

return {
  snacks = snacks,
}
