return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "TroubleToggle", "Trouble" },
  keys = {
    { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location List" },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List" },
    { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "LSP References" },
  },
  opts = {
    position = "bottom",         -- position of the list ("bottom" or "right")
    height = 10,                 -- height of the list when position is "bottom"
    width = 50,                  -- width of the list when position is "right"
    icons = true,                -- use devicons for filenames
    mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    auto_open = false,           -- automatically open when diagnostics are present
    auto_close = true,           -- automatically close when no diagnostics
    use_diagnostic_signs = true, -- show the signs in the signcolumn
  },
}
