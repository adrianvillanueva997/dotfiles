return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {"nvim-lua/plenary.nvim", {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
    }, "nvim-tree/nvim-web-devicons", {"nvim-telescope/telescope-file-browser.nvim"}},
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local themes = require("telescope.themes")
        local builtin = require("telescope.builtin")

        telescope.setup({
            defaults = {
                prompt_prefix = "🔍 ",
                selection_caret = " ",
                path_display = {"truncate"},
                layout_config = {
                    horizontal = {
                        preview_width = 0.55
                    },
                    vertical = {
                        mirror = false
                    }
                },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next, -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist
                    }
                }
            },
            extensions = {
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case" -- or "ignore_case" or "respect_case"
                },
                file_browser = {
                    hijack_netrw = true
                }
            }
        })

        telescope.load_extension("fzf")
        telescope.load_extension("file_browser")

        -- set keymaps
        local keymap = vim.keymap.set -- for conciseness

        keymap("n", "<leader>ff", function()
            builtin.find_files(themes.get_dropdown({
                previewer = true
            }))
        end, {
            desc = "Fuzzy find files in cwd"
        })

        keymap("n", "<leader>fr", function()
            builtin.oldfiles(themes.get_dropdown({
                previewer = true
            }))
        end, {
            desc = "Fuzzy find recent files"
        })

        keymap("n", "<leader>fs", function()
            builtin.live_grep(themes.get_ivy())
        end, {
            desc = "Find string in cwd"
        })

        keymap("n", "<leader>fc", function()
            builtin.grep_string(themes.get_ivy())
        end, {
            desc = "Find string under cursor in cwd"
        })

        keymap("n", "<leader>fb", function()
            telescope.extensions.file_browser.file_browser(themes.get_ivy())
        end, {
            desc = "Telescope file browser"
        })

        keymap("n", "<leader>fd", function()
            builtin.diagnostics(themes.get_ivy())
        end, {
            desc = "Open diagnostics"
        })
    end
}
