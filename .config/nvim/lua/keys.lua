local map = vim.api.nvim_set_keymap

map('n', 'n', [[:NvimTreeToggle]], {})

-- Toggle more plugins
-- map('n', 'l', [[:IndentLinesToggle]], {})
map('n', 'ff', [[:Telescope find_files]], {})
map('n', 'tt', [[:FloatermNew]], {})