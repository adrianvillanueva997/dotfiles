return {
    "stevearc/conform.nvim",
    event = {"BufReadPre", "BufNewFile"},
    opts = {
        formatters_by_ft = {
            lua = {"stylua"},
            python = {"ruff_format", "ruff_organize_imports"},
            rust = {"rustfmt"},
            -- Conform will run the first available formatter
            javascript = {
                "biome",
                stop_after_first = true
            },
            typescript = {
                "biome",
                stop_after_first = true
            }
        },
        format_on_save = {
            lsp_fallback = true,
            async = false,
            timeout_ms = 500
        }
    },
    keys = {{
        "<leader>cf",
        function()
            require("conform").format({
                async = true,
                lsp_fallback = true
            })
        end,
        mode = "",
        desc = "Format buffer"
    }}
}
