---@module 'lazy'
---@type LazySpec
return {
  'nvimtools/none-ls.nvim',
  config = function()
    local nonels = require 'null-ls'
    local fmt = nonels.builtins.formatting
    local cmp = nonels.builtins.completion
    local ca = nonels.builtins.code_actions
    local lint = nonels.builtins.diagnostics
    local hover = nonels.builtins.hover

    nonels.setup {
      log = {
        enable = true,
        level = 'warn',
      },
      sources = {
        lint.selene,
      },
    }
  end,
}
