return {
    "akinsho/bufferline.nvim",
    enabled = false,
    dependencies = {"nvim-tree/nvim-web-devicons"},
    version = "*",
    opts = {
        options = {
            mode = "tabs", -- set to "tabs" to only show tabpages instead

            separator_style = "slant", -- | "thick" | "thin" | { 'any', 'any' },
            diagnostics = "nvim_lsp",
            always_show_bufferline = true,
            offsets = {{
                filetype = "neo-tree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
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
    }}
}
