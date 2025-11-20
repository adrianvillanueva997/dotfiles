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
    end
}
