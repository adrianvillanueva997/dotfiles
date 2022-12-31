return {

  -- tokyonight
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local kanagawa = require("kanagawa")
      kanagawa.setup({ theme = "default"})
      kanagawa.load()
    end,
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
}
