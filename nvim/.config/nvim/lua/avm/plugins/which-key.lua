return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {
        spec = {{
            "<leader>b",
            group = "Buffers"
        }, {
            "<leader>c",
            group = "Code"
        }, {
            "<leader>e",
            desc = "Explorer"
        }, {
            "<leader>f",
            group = "Find"
        }, {
            "<leader>g",
            group = "Git"
        }, {
            "<leader>h",
            group = "Git Hunk"
        }, {
            "<leader>l",
            group = "LSP"
        }, {
            "<leader>t",
            group = "Toggle"
        }, {
            "<leader>x",
            group = "Trouble / Diagnostics"
        }}
    }
}
