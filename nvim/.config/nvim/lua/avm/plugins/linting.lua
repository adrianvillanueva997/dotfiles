return {
    "mfussenegger/nvim-lint",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"williamboman/mason.nvim", "rshkarin/mason-nvim-lint"},
    config = function()
        local lint = require("lint")
        local mason_lint = require("mason-nvim-lint")

        mason_lint.setup({
            ensure_installed = {"ruff", -- Python linter
            "eslint_d" -- JS/TS linter
            },
            automatic_installation = true
        })

        lint.linters_by_ft = {
            python = {"ruff"},
            javascript = {"eslint_d"},
            typescript = {"eslint_d"},
            javascriptreact = {"eslint_d"},
            typescriptreact = {"eslint_d"}
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", {
            clear = true
        })

        vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost", "InsertLeave"}, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end
        })

        vim.keymap.set("n", "<leader>cl", function()
            lint.try_lint()
        end, {
            desc = "Trigger linting for current file"
        })
    end
}
