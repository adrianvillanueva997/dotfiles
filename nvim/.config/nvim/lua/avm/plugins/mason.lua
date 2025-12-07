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
        ensure_installed = {"lua_ls", "basedpyright", "rust_analyzer", "gopls", "ts_ls", "zls"},
        automatic_installation = true
    },
    config = function(_, opts)
        local mason_lspconfig = require("mason-lspconfig")
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- Global LspAttach autocommand for keymaps and options
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {
                clear = true
            }),
            callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, {
                        buffer = event.buf,
                        desc = "LSP: " .. desc
                    })
                end

                -- Standard LSP Keymaps
                map("gd", vim.lsp.buf.definition, "Go to Definition")
                map("gr", require("telescope.builtin").lsp_references, "Go to References")
                map("gI", require("telescope.builtin").lsp_implementations, "Go to Implementation")
                map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
                map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
                map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
                map("<leader>rn", vim.lsp.buf.rename, "Rename")
                map("K", vim.lsp.buf.hover, "Hover Documentation")
                map("gD", vim.lsp.buf.declaration, "Go to Declaration")

                -- Diagnostics
                map("<leader>d", vim.diagnostic.open_float, "Show Line Diagnostics")
                map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
                map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
                map("<leader>q", vim.diagnostic.setloclist, "Open Diagnostic List")

                -- Enable Inlay Hints if supported
                if client.server_capabilities.inlayHintProvider then
                    -- vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
                            bufnr = event.buf
                        }), {
                            bufnr = event.buf
                        })
                    end, "Toggle Inlay Hints")
                end
            end
        })

        mason_lspconfig.setup({
            ensure_installed = opts.ensure_installed,
            automatic_installation = opts.automatic_installation,
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities
                    })
                end,
                ["ts_ls"] = function()
                    require("lspconfig").ts_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            typescript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = "all",
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                    includeInlayPropertyDeclarationTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayEnumMemberValueHints = true
                                }
                            },
                            javascript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = "all",
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                    includeInlayPropertyDeclarationTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayEnumMemberValueHints = true
                                }
                            }
                        }
                    })
                end,
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                hint = {
                                    enable = true
                                }
                            }
                        }
                    })
                end,
                ["rust_analyzer"] = function()
                end,
                ["gopls"] = function()
                end,
                ["basedpyright"] = function()
                    require("lspconfig").basedpyright.setup({
                        capabilities = capabilities,
                        settings = {
                            basedpyright = {
                                analysis = {
                                    inlayHints = {
                                        variableTypes = true,
                                        functionReturnTypes = true,
                                        callArgumentNames = true,
                                        pytestParameters = true
                                    }
                                }
                            }
                        }
                    })
                end
            }
        })
    end
}, -- Mason Tool Installer (formatters, linters)
{
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    opts = {
        ensure_installed = {"stylua", "shellcheck", "shfmt", "ruff", "biome", "golangci-lint", "codelldb", "delve",
                            "gofumpt"}
    }
}}
