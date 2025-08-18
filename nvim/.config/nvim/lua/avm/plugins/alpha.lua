return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Dark Doom/Black Metal ASCII Logo
    dashboard.section.header.val = {
      [[     ███████████████████████████     ]],
      [[  ████████████████████████████████   ]],
      [[ ███████▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀███████  ]],
      [[ ██████      ▄▄▄▄▄▄▄▄       ███████  ]],
      [[ ██████    ▄█▀      ▀█▄     ███████  ]],
      [[ ██████   ██   ▄██▄   ██    ███████  ]],
      [[ ██████   ██  ██▀███  ██    ███████  ]],
      [[ ██████    ▀█▄ ▀██▀ ▄█▀     ███████  ]],
      [[ ██████      ▀▀▄▄▄▄▀▀       ███████  ]],
      [[ ███████▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄████████  ]],
      [[  ████████████████████████████████   ]],
      [[     ███████████████████████████     ]],
      [[                                       ]],
      [[       ☠ D O O M    V I M ☠           ]],
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
      dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
      dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Apply
    alpha.setup(dashboard.opts)
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
