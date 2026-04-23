return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { "%.git/" },
        hidden = true,
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        exclude = { ".git", "node_modules" },
        hidden = true,
        ignored = true,
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
          files = {
            hidden = true,
            ignored = true,
          },
          grep = {
            args = { "--glob", "!**/.git/*" },
          },
        },
      },
    },
  },
}
