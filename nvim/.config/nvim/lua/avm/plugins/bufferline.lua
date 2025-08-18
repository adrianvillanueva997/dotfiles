return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      mode = "tabs",                     -- show buffers as tabs
      separator_style = "slant",         -- slanted separators
      always_show_bufferline = true,     -- always display the bar
      show_buffer_close_icons = true,    -- show close icons on buffers
      show_close_icon = false,           -- hide the main close icon
      show_tab_indicators = true,        -- indicators for unsaved buffers
      enforce_regular_tabs = false,      -- let tabs adjust width
      themable = true,                   -- allow theme colors to override
      diagnostics = "nvim_lsp",          -- show LSP diagnostics in tab
      offsets = {
        { filetype = "NvimTree", text = "", padding = 1 }, -- adjust for file explorer
      },
    },
  },
}
