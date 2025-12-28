return {
    "HiPhish/rainbow-delimiters.nvim",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"nvim-treesitter/nvim-treesitter"},
    config = function()
        local rainbow_delimiters = require("rainbow-delimiters")

        vim.g.rainbow_delimiters = {
            strategy = {
                [""] = rainbow_delimiters.strategy["global"],
                vim = rainbow_delimiters.strategy["local"],
                vimdoc = rainbow_delimiters.strategy["local"]
            },
            query = {
                [""] = "rainbow-delimiters",
                lua = "rainbow-blocks",
                tsx = "rainbow-parens",
                jsx = "rainbow-parens",
                javascript = "rainbow-parens",
                typescript = "rainbow-parens"
            },
            highlight = {"RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue",
                         "RainbowDelimiterOrange", "RainbowDelimiterGreen", "RainbowDelimiterViolet",
                         "RainbowDelimiterCyan"}
        }
    end
}
