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
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
          "%.next/",
          "dist/",
          "build/",
          "coverage/",
          "%.cache/",
          "%.venv/",
          "__pycache__/",
          "%.terraform/",
          "target/",
        },
        hidden = true,
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        exclude = {
          ".git",
          "node_modules",
          ".next",
          "dist",
          "build",
          "coverage",
          ".cache",
          ".venv",
          "__pycache__",
          ".terraform",
          "target",
        },
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
