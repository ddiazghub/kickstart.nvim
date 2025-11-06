---@module 'lazy'
---@type LazySpec
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '▟', show_count = true },
      topdelete = { text = '▜', show_count = true },
      changedelete = { text = '┃', show_count = true },
      untracked = { text = '┆' },
    },
    current_line_blame = true,
    attach_to_untracked = true,
  },
}
