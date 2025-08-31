return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			-- keep default if you still want <C-\> for general terminal
			open_mapping = [[<C-\>]],
		},
		keys = {
			{
				"<leader>t",
				function()
					require("toggleterm.terminal").Terminal:new({ direction = "float" }):toggle()
				end,
				desc = "Toggle floating terminal",
			},
		},
	},
}
