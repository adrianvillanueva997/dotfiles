return { -- blink.cmp
	{
		"saghen/blink.cmp",
		lazy = false,
		dependencies = "rafamadriz/friendly-snippets",
		build = "cargo build --release",
		opts = {
			keymap = {
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },
				["<C-y>"] = { "select_and_accept" },
				["<CR>"] = { "select_and_accept", "fallback" },

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			completion = {
				menu = {
					border = "rounded",
				},
				documentation = {
					auto_show = true,
					window = {
						border = "rounded",
					},
				},
			},
			signature = {
				enabled = true,
				window = {
					border = "rounded",
				},
			},
			fuzzy = {
				prebuilt_binaries = {
					download = true,
					force_version = nil,
				},
			},
		},
	}, -- LSP file operations (rename/move files with LSP)
	{
		"antosha417/nvim-lsp-file-operations",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	}, -- Lazydev for Lua dev
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = { {
				path = "${3rd}/plenary.nvim/lua",
				words = { "plenary" },
			} },
		},
	},
}
