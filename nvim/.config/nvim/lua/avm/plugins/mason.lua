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
            border = "rounded",
            width = 0.8,
            height = 0.8
        },
        max_concurrent_installers = 10
    }
}, -- Mason LSPConfig: only LSP servers
{
    "mason-org/mason-lspconfig.nvim",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"mason-org/mason.nvim", "neovim/nvim-lspconfig"},
    opts = {
        ensure_installed = {"lua_ls", "basedpyright", "ruff", "gopls", "ts_ls", "zls"},
        automatic_installation = true
    },
    config = function(_, opts)
        local mason_lspconfig = require("mason-lspconfig")
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- Better diagnostic configuration
        vim.diagnostic.config({
            virtual_text = {
                spacing = 4,
                prefix = "●",
                severity = {
                    min = vim.diagnostic.severity.HINT
                }
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                border = "rounded",
                source = "if_many",
                header = "",
                prefix = ""
            }
        })

        -- Custom diagnostic signs
        local signs = {
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = " "
        }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, {
                text = icon,
                texthl = hl,
                numhl = hl
            })
        end

        -- Wrap inlay hint functions to suppress errors
        local original_enable = vim.lsp.inlay_hint.enable
        vim.lsp.inlay_hint.enable = function(enable, filter)
            local ok, result = pcall(original_enable, enable, filter)
            if not ok then
                -- Silently ignore inlay hint errors
                return
            end
            return result
        end

        -- Global LspAttach autocommand for keymaps and options
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {
                clear = true
            }),
            callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if not client then
                    return
                end

                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, {
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

                -- Code actions
                map("<leader>ca", vim.lsp.buf.code_action, "Code Action", {"n", "v"})

                -- Highlight symbol under cursor
                if client.supports_method("textDocument/documentHighlight") then
                    local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", {
                        clear = false
                    })
                    vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight
                    })
                    vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references
                    })
                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("lsp-detach", {
                            clear = true
                        }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({
                                group = "lsp-highlight",
                                buffer = event2.buf
                            })
                        end
                    })
                end

                -- Enable Inlay Hints if supported (wrapped to catch errors)
                if client.supports_method("textDocument/inlayHint") then
                    pcall(vim.lsp.inlay_hint.enable, true, {
                        bufnr = event.buf
                    })

                    map("<leader>th", function()
                        pcall(function()
                            local enabled = vim.lsp.inlay_hint.is_enabled({
                                bufnr = event.buf
                            })
                            vim.lsp.inlay_hint.enable(not enabled, {
                                bufnr = event.buf
                            })
                        end)
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
                        on_attach = function(client, bufnr)
                            -- Enable inlay hints for TypeScript
                            if client.supports_method("textDocument/inlayHint") then
                                vim.lsp.inlay_hint.enable(true, {
                                    bufnr = bufnr
                                })
                            end
                        end,
                        settings = {
                            typescript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = "all",
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = true, -- Changed to true
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                    includeInlayVariableTypeHintsWhenTypeMatchesName = true, -- Added
                                    includeInlayPropertyDeclarationTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayEnumMemberValueHints = true
                                }
                            },
                            javascript = {
                                inlayHints = {
                                    includeInlayParameterNameHints = "all",
                                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                    includeInlayFunctionParameterTypeHints = true,
                                    includeInlayVariableTypeHints = true,
                                    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
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
                                runtime = {
                                    version = "LuaJIT"
                                },
                                workspace = {
                                    checkThirdParty = false,
                                    library = {vim.env.VIMRUNTIME}
                                },
                                completion = {
                                    callSnippet = "Replace"
                                },
                                hint = {
                                    enable = true
                                },
                                telemetry = {
                                    enable = false
                                }
                            }
                        }
                    })
                end,
                -- rust_analyzer is handled by rustaceanvim, so we skip it
                ["rust_analyzer"] = function()
                end,
                ["gopls"] = function()
                    require("lspconfig").gopls.setup({
                        capabilities = capabilities,
                        settings = {
                            gopls = {
                                analyses = {
                                    unusedparams = true,
                                    shadow = true
                                },
                                staticcheck = true,
                                gofumpt = true,
                                hints = {
                                    assignVariableTypes = true,
                                    compositeLiteralFields = true,
                                    compositeLiteralTypes = true,
                                    constantValues = true,
                                    functionTypeParameters = true,
                                    parameterNames = true,
                                    rangeVariableTypes = true
                                }
                            }
                        }
                    })
                end,
                ["basedpyright"] = function()
                    require("lspconfig").basedpyright.setup({
                        capabilities = capabilities,
                        settings = {
                            basedpyright = {
                                analysis = {
                                    autoSearchPaths = true,
                                    diagnosticMode = "openFilesOnly",
                                    useLibraryCodeForTypes = true,
                                    typeCheckingMode = "standard",
                                    autoImportCompletions = true,
                                    diagnosticSeverityOverrides = {
                                        reportUnusedImport = "information",
                                        reportUnusedVariable = "information"
                                    },
                                    inlayHints = {
                                        variableTypes = true,
                                        functionReturnTypes = true,
                                        callArgumentNames = "partial",
                                        pytestParameters = true
                                    }
                                }
                            }
                        }
                    })
                end,
                ["ruff"] = function()
                    require("lspconfig").ruff.setup({
                        capabilities = capabilities,
                        init_options = {
                            settings = {
                                lineLength = 88,
                                lint = {
                                    enable = true,
                                    select = {"ALL"}
                                },
                                format = {
                                    preview = true
                                }
                            }
                        },
                        on_attach = function(client, bufnr)
                            client.server_capabilities.hoverProvider = false

                            -- Format with Ruff on save
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                buffer = bufnr,
                                callback = function()
                                    vim.lsp.buf.format({
                                        async = false,
                                        filter = function(c)
                                            return c.name == "ruff"
                                        end
                                    })
                                end
                            })
                        end
                    })
                end,
                ["zls"] = function()
                    require("lspconfig").zls.setup({
                        capabilities = capabilities,
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                inlay_hints_show_variable_type_hints = true,
                                inlay_hints_show_parameter_name = true
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
        ensure_installed = { -- Lua
        "stylua", -- Shell
        "shellcheck", "shfmt", -- Python
        "ruff", -- JavaScript/TypeScript
        "biome", "prettier", -- Go
        "golangci-lint", "gofumpt", "goimports", -- Debuggers
        "codelldb", "delve"},
        auto_update = false,
        run_on_start = true
    }
}}
