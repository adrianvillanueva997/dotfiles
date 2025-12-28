return {
    "akinsho/bufferline.nvim",
    enabled = false, -- Using tabby.nvim instead
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"nvim-tree/nvim-web-devicons"},
    version = "*",
    opts = {
        options = {
            mode = "buffers",
            themable = true,
            numbers = "none",
            close_command = "bdelete! %d",
            right_mouse_command = "bdelete! %d",
            left_mouse_command = "buffer %d",
            indicator = {
                icon = "▎",
                style = "icon"
            },
            buffer_close_icon = "󰅖",
            modified_icon = "●",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            max_name_length = 30,
            max_prefix_length = 30,
            truncate_names = true,
            tab_size = 21,
            diagnostics = "nvim_lsp",
            diagnostics_update_in_insert = false,
            diagnostics_indicator = function(count, level, _, _)
                local icon = level:match("error") and " " or " "
                return " " .. icon .. count
            end,
            color_icons = true,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = true,
            show_tab_indicators = true,
            show_duplicate_prefix = true,
            persist_buffer_sort = true,
            separator_style = "thin",
            enforce_regular_tabs = false,
            always_show_bufferline = true,
            hover = {
                enabled = true,
                delay = 200,
                reveal = {"close"}
            },
            sort_by = "insert_after_current",
            offsets = {{
                filetype = "neo-tree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left",
                separator = true
            }}
        }
    },
    keys = {{
        "<leader>bp",
        "<Cmd>BufferLineTogglePin<CR>",
        desc = "Toggle Pin"
    }, {
        "<leader>bP",
        "<Cmd>BufferLineGroupClose ungrouped<CR>",
        desc = "Delete Non-Pinned Buffers"
    }, {
        "<leader>bo",
        "<Cmd>BufferLineCloseOthers<CR>",
        desc = "Delete Other Buffers"
    }, {
        "<leader>br",
        "<Cmd>BufferLineCloseRight<CR>",
        desc = "Delete Buffers to the Right"
    }, {
        "<leader>bl",
        "<Cmd>BufferLineCloseLeft<CR>",
        desc = "Delete Buffers to the Left"
    }, {
        "<leader>bs",
        "<Cmd>BufferLineSortByDirectory<CR>",
        desc = "Sort by Directory"
    }, {
        "<leader>bS",
        "<Cmd>BufferLineSortByExtension<CR>",
        desc = "Sort by Extension"
    }, {
        "<S-h>",
        "<cmd>BufferLineCyclePrev<cr>",
        desc = "Prev Buffer"
    }, {
        "<S-l>",
        "<cmd>BufferLineCycleNext<cr>",
        desc = "Next Buffer"
    }, {
        "[b",
        "<cmd>BufferLineCyclePrev<cr>",
        desc = "Prev Buffer"
    }, {
        "]b",
        "<cmd>BufferLineCycleNext<cr>",
        desc = "Next Buffer"
    }, {
        "<A-h>",
        "<cmd>BufferLineMovePrev<cr>",
        desc = "Move Buffer Left"
    }, {
        "<A-l>",
        "<cmd>BufferLineMoveNext<cr>",
        desc = "Move Buffer Right"
    }, {
        "<leader>b1",
        "<Cmd>BufferLineGoToBuffer 1<CR>",
        desc = "Go to Buffer 1"
    }, {
        "<leader>b2",
        "<Cmd>BufferLineGoToBuffer 2<CR>",
        desc = "Go to Buffer 2"
    }, {
        "<leader>b3",
        "<Cmd>BufferLineGoToBuffer 3<CR>",
        desc = "Go to Buffer 3"
    }, {
        "<leader>b4",
        "<Cmd>BufferLineGoToBuffer 4<CR>",
        desc = "Go to Buffer 4"
    }, {
        "<leader>b5",
        "<Cmd>BufferLineGoToBuffer 5<CR>",
        desc = "Go to Buffer 5"
    }, {
        "<leader>b$",
        "<Cmd>BufferLineGoToBuffer -1<CR>",
        desc = "Go to Last Buffer"
    }}
}
