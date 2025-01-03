return {
    "williamboman/mason.nvim",
    dependencies = {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_tool_installer = require("mason-tool-installer")
        local mason_lspconfig = require("mason-lspconfig")

        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            ensure_installed = {
                "ts_ls",
                "html",
                "cssls",
                "tailwindcss",
                "lua_ls",
                "pyright",
                "terraformls",
            },
            automatic_installation = true,
        })

        mason_tool_installer.setup({
            ensure_installed = {
                "prettier",
                "stylua",
                "eslint_d",
                "ruff",
                "luacheck",
                "tflint",
                "tfsec",
                "biome",
            },
        })
    end,
}
