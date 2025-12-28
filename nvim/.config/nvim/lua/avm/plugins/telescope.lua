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
        desc = "Find files"
    }, {
        "<leader>fF",
        "<cmd>Telescope find_files hidden=true no_ignore=true<cr>",
        desc = "Find all files (hidden)"
    }, {
        "<leader>fr",
        "<cmd>Telescope oldfiles<cr>",
        desc = "Recent files"
    }, {
        "<leader>fs",
        "<cmd>Telescope live_grep<cr>",
        desc = "Grep string"
    }, {
        "<leader>fw",
        "<cmd>Telescope grep_string<cr>",
        desc = "Grep word under cursor"
    }, {
        "<leader>fb",
        "<cmd>Telescope buffers<cr>",
        desc = "Find buffers"
    }, {
        "<leader>fh",
        "<cmd>Telescope help_tags<cr>",
        desc = "Help tags"
    }, {
        "<leader>fd",
        "<cmd>Telescope diagnostics<cr>",
        desc = "Diagnostics"
    }, {
        "<leader>fk",
        "<cmd>Telescope keymaps<cr>",
        desc = "Keymaps"
    }, {
        "<leader>fc",
        "<cmd>Telescope commands<cr>",
        desc = "Commands"
    }, {
        "<leader>fg",
        "<cmd>Telescope git_status<cr>",
        desc = "Git status"
    }, {
        "<leader>f/",
        "<cmd>Telescope current_buffer_fuzzy_find<cr>",
        desc = "Fuzzy search in buffer"
    }, {
        "<leader><leader>",
        "<cmd>Telescope buffers<cr>",
        desc = "Find buffers"
    }},
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        -- Shared mappings to reduce repetition
        local open_in_tab = {
            n = {
                ["<CR>"] = actions.select_tab
            },
            i = {
                ["<CR>"] = actions.select_tab
            }
        }

        telescope.setup({
            defaults = {
                path_display = {"truncate"},
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "bottom",
                        preview_width = 0.55
                    },
                    vertical = {
                        mirror = false
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120
                },
                file_ignore_patterns = {"node_modules", ".git/", "%.lock", "__pycache__", "%.pyc", "%.class", "%.pdf",
                                        "%.mkv", "%.mp4", "%.zip", "%.tar.gz", "%.o", "%.a", "%.out", "%.DS_Store",
                                        "%.cache", "dist/", "build/", "target/"},
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                        ["<C-x>"] = actions.select_horizontal,
                        ["<C-v>"] = actions.select_vertical,
                        ["<C-t>"] = actions.select_tab,
                        ["<Esc>"] = actions.close
                    },
                    n = {
                        ["q"] = actions.close,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist
                    }
                }
            },
            pickers = {
                find_files = {
                    hidden = false, -- Use <leader>fF for hidden files
                    mappings = open_in_tab
                },
                oldfiles = {
                    mappings = open_in_tab
                },
                live_grep = {
                    additional_args = {"--hidden", "--glob", "!.git/"},
                    mappings = open_in_tab
                },
                grep_string = {
                    additional_args = {"--hidden", "--glob", "!.git/"},
                    mappings = open_in_tab
                },
                buffers = {
                    show_all_buffers = true,
                    sort_lastused = true,
                    mappings = {
                        i = {
                            ["<C-d>"] = actions.delete_buffer
                        },
                        n = {
                            ["d"] = actions.delete_buffer
                        }
                    }
                }
            }
        })

        telescope.load_extension("fzf")
    end
}
