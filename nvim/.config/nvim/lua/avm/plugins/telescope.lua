return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {"nvim-lua/plenary.nvim", {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
    }, "nvim-tree/nvim-web-devicons"},
    keys = {{
        "<leader>ff",
        "<cmd>Telescope find_files<cr>",
        desc = "Fuzzy find files in cwd"
    }, {
        "<leader>fr",
        "<cmd>Telescope oldfiles<cr>",
        desc = "Fuzzy find recent files"
    }, {
        "<leader>fs",
        "<cmd>Telescope live_grep<cr>",
        desc = "Find string in cwd"
    }, {
        "<leader>fc",
        "<cmd>Telescope grep_string<cr>",
        desc = "Find string under cursor in cwd"
    }, {
        "<leader>fb",
        "<cmd>Telescope buffers<cr>",
        desc = "Find buffers"
    }, {
        "<leader>fh",
        "<cmd>Telescope help_tags<cr>",
        desc = "Find help tags"
    }},
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                path_display = {"truncate "},
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next, -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<CR>"] = actions.select_tab -- Open in new tab on Enter
                    },
                    n = {
                        ["<CR>"] = actions.select_tab -- Open in new tab on Enter
                    }
                }
            }
        })

        telescope.load_extension("fzf")
    end
}
