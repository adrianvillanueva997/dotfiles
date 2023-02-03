vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

vim.cmd("colorscheme kanagawa")
vim.opt.list = true
vim.opt.listchars:append "eol:↴"

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.wo.number = true

-- Lua
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {
	silent = true,
	noremap = true
})
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", {
	silent = true,
	noremap = true
})
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", {
	silent = true,
	noremap = true
})
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", {
	silent = true,
	noremap = true
})
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", {
	silent = true,
	noremap = true
})
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", {
	silent = true,
	noremap = true
})
