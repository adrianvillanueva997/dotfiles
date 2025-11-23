return {
    "nanozuki/tabby.nvim",
    config = function()
        vim.o.showtabline = 2
        require("tabby.tabline").use_preset("active_wins_at_tail", {
            theme = {
                fill = "TabLineFill", -- tabline background
                head = "TabLine", -- head element
                current_tab = "TabLineSel", -- current tab
                tab = "TabLine", -- other tabs
                win = "TabLine", -- windows
                tail = "TabLine" -- tail element
            },
            nerdfont = true -- whether use nerdfont
        })
    end,
    keys = {{
        "<leader>ta",
        "<cmd>$tabnew<cr>",
        desc = "New Tab"
    }, {
        "<leader>tc",
        "<cmd>tabclose<cr>",
        desc = "Close Tab"
    }, {
        "<leader>to",
        "<cmd>tabonly<cr>",
        desc = "Close Other Tabs"
    }, {
        "<leader>tn",
        "<cmd>tabn<cr>",
        desc = "Next Tab"
    }, {
        "<leader>tp",
        "<cmd>tabp<cr>",
        desc = "Previous Tab"
    }, {
        "<leader>tmp",
        "<cmd>-tabmove<cr>",
        desc = "Move Tab Previous"
    }, {
        "<leader>tmn",
        "<cmd>+tabmove<cr>",
        desc = "Move Tab Next"
    }}
}
