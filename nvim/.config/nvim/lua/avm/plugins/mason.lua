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

        local on_attach = function(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true, {
                    bufnr = bufnr
                })
            end
        end

        mason_lspconfig.setup({
            ensure_installed = opts.ensure_installed,
            automatic_installation = opts.automatic_installation,
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach
                    })
                end,
                ["ts_ls"] = function()
                    require("lspconfig").ts_ls.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
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
                        on_attach = on_attach,
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
                    require("lspconfig").rust_analyzer.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            ["rust-analyzer"] = {
                                inlayHints = {
                                    bindingModeHints = {
                                        enable = true
                                    },
                                    chainingHints = {
                                        enable = true
                                    },
                                    closingBraceHints = {
                                        enable = true,
                                        minLines = 25
                                    },
                                    closureReturnTypeHints = {
                                        enable = "always"
                                    },
                                    lifetimeElisionHints = {
                                        enable = "always",
                                        useParameterNames = true
                                    },
                                    maxLength = 25,
                                    parameterHints = {
                                        enable = true
                                    },
                                    reborrowHints = {
                                        enable = "always"
                                    },
                                    renderColons = true,
                                    typeHints = {
                                        enable = true,
                                        hideClosureInitialization = false,
                                        hideNamedConstructor = false
                                    }
                                }
                            }
                        }
                    })
                end,
                ["basedpyright"] = function()
                    require("lspconfig").basedpyright.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
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
        ensure_installed = {"stylua", "shellcheck", "shfmt", "ruff", "biome", "golangci-lint"}
    }
}}
