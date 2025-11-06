local darkgray = '#555555'

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
vim.api.nvim_set_hl(0, 'StatuslineFilename', { bg = darkgray, fg = '#FFFFFF' })
vim.api.nvim_set_hl(0, 'StatuslineProjectName', { bg = '#383a42', fg = '#FFFFFF' })

-- Gitsigns
local function gitsigns()
  vim.api.nvim_set_hl(0, 'StatuslineDiffAdd', { fg = '#83ff98', bg = darkgray })
  vim.api.nvim_set_hl(0, 'StatuslineDiffChange', { fg = '#ecce7b', bg = darkgray })
  vim.api.nvim_set_hl(0, 'StatuslineDiffDelete', { fg = '#ec5f67', bg = darkgray })

  vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#83ff98' })
  vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#ecce7b' })
  vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#ec5f67' })
end

return {
  gitsigns = gitsigns,
}
