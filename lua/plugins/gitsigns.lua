return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_', show_count = true },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    current_line_blame = true,
  },
}
