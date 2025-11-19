return { -- Mason core
{
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            },
            border = "rounded"
        }
    }
}, -- Mason LSPConfig: only LSP servers
{
    "mason-org/mason-lspconfig.nvim",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"mason-org/mason.nvim", "neovim/nvim-lspconfig"},
    opts = {
        ensure_installed = {"lua_ls", "basedpyright", "rust_analyzer", "gopls", "tsserver", "zls"},
        automatic_installation = true
    },
    config = function(_, opts)
        local mason_lspconfig = require("mason-lspconfig")
        mason_lspconfig.setup(opts)

        local capabilities = require("blink.cmp").get_lsp_capabilities()
        local lspconfig = require("lspconfig")

        -- Version-safe: loop over installed servers
        local installed_servers = mason_lspconfig.get_installed_servers()
        for _, server_name in ipairs(installed_servers) do
            -- NEW 0.11+ API
            vim.lsp.config[server_name] = vim.tbl_deep_extend("force", vim.lsp.config[server_name] or {}, {
                capabilities = capabilities
            })
            vim.lsp.enable(server_name)
        end
    end
}, -- Mason Tool Installer (formatters, linters)
{
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    opts = {
        ensure_installed = {"stylua", "shellcheck", "shfmt", "ruff", "biome", "golangci-lint"}
    }
}}
