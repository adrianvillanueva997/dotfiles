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
    {
      {
        "folke/snacks.nvim",
        opts = {
          picker = {
            sources = {
              explorer = {
                hidden = true,
                ignored = true,
              },
              files = {
                hidden = true, -- show dotfiles in fuzzy finder
                ignored = true, -- optional: show gitignored files
              },
            },
          },
        },
      },
    },
  },
}
