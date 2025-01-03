return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local themes = require("telescope.themes")

        telescope.setup({
            defaults = {
                prompt_prefix = "🔍 ",
                selection_caret = " ",
                path_display = { "truncate" },
                layout_config = {
                    horizontal = { preview_width = 0.55 },
                    vertical = { mirror = false },
                },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next, -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                },
            },
        })

        telescope.load_extension("fzf")

        -- set keymaps
        local keymap = vim.keymap.set -- for conciseness

        keymap("n", "<leader>ff", function()
            telescope.builtin.find_files(themes.get_dropdown({ previewer = false }))
        end, { desc = "Fuzzy find files in cwd" })

        keymap("n", "<leader>fr", function()
            telescope.builtin.oldfiles(themes.get_dropdown({ previewer = false }))
        end, { desc = "Fuzzy find recent files" })

        keymap("n", "<leader>fs", function()
            telescope.builtin.live_grep(themes.get_ivy())
        end, { desc = "Find string in cwd" })

        keymap("n", "<leader>fc", function()
            telescope.builtin.grep_string(themes.get_ivy())
        end, { desc = "Find string under cursor in cwd" })
    end,
}
