---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      hint = {
        enable = true, -- Enable inlay hints
        arrayIndex = 'Auto', -- Show hints for array indices
        await = true, -- Show hints for await expressions
        paramName = 'All', -- 'All', 'Literal', or 'Disable'
        paramType = true, -- Show parameter types
        semicolon = 'Disable', -- Show semicolons hints
        setType = true, -- Show variable type hints
      },
    },
  },
}
