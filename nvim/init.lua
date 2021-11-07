require('plugins/boostrap')
require('plugins/init')
require('treesitter-config')
require('options')
require('lualine-config')
require('bufferline-config')
require('tree-config')
--vim.g.material_style = "deep ocean"
-- Example config in Lua
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

-- Change the "hint" color to the "orange" color, and make the "error" color bright red
vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }

-- Load the colorscheme
vim.cmd('nnoremap <C-n> :NvimTreeToggle<CR>')

vim.o.termguicolors = true
vim.cmd[[colorscheme tokyonight]]
