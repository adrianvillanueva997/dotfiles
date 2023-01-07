-- Add any servers here together with their settings
---@type lspconfig.options
local servers = {
  bashls = {},
  clangd = {},
  cssls = {},
  tsserver = {},
  html = {},
  jsonls = {},
  gopls = {},
  pyright = {},
  rust_analyzer = {},
  yamlls = {},
  sumneko_lua = {
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
  terraformls = {},
}

return servers
