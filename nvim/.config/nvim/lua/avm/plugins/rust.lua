return {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    dependencies = {"mason-org/mason.nvim", "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap"},
    config = function()
        vim.g.rustaceanvim = {
            dap = {},
            server = {
                on_attach = function(client, bufnr)
                    -- Enable inlay hints by default for Rust
                    vim.lsp.inlay_hint.enable(true, {
                        bufnr = bufnr
                    })

                    -- Set up keymaps
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, {
                            buffer = bufnr,
                            desc = "Rust: " .. desc
                        })
                    end

                    -- Rustacean-specific keymaps
                    map("<leader>rc", function()
                        vim.cmd.RustLsp("codeAction")
                    end, "Code Action")
                    map("<leader>rr", function()
                        vim.cmd.RustLsp("runnables")
                    end, "Runnables")
                    map("<leader>rd", function()
                        vim.cmd.RustLsp("debuggables")
                    end, "Debuggables")
                    map("<leader>re", function()
                        vim.cmd.RustLsp("expandMacro")
                    end, "Expand Macro")
                    map("K", function()
                        vim.cmd.RustLsp({"hover", "actions"})
                    end, "Hover Actions")

                    -- Inlay hint toggle
                    map("<leader>th", function()
                        local enabled = vim.lsp.inlay_hint.is_enabled({
                            bufnr = bufnr
                        })
                        vim.lsp.inlay_hint.enable(not enabled, {
                            bufnr = bufnr
                        })
                    end, "Toggle Inlay Hints")
                end,
                default_settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            buildScripts = {
                                enable = true
                            }
                        },
                        checkOnSave = {
                            command = "clippy",
                            extraArgs = {"--no-deps"}
                        },
                        procMacro = {
                            enable = true,
                            ignored = {
                                ["async-trait"] = {"async_trait"},
                                ["napi-derive"] = {"napi"},
                                ["async-recursion"] = {"async_recursion"}
                            }
                        },
                        diagnostics = {
                            enable = true,
                            experimental = {
                                enable = true
                            }
                        },
                        inlayHints = {
                            bindingModeHints = {
                                enable = false -- Less noisy
                            },
                            chainingHints = {
                                enable = true
                            },
                            closingBraceHints = {
                                enable = true,
                                minLines = 10 -- Show for smaller blocks
                            },
                            closureReturnTypeHints = {
                                enable = "always"
                            },
                            lifetimeElisionHints = {
                                enable = "skip_trivial", -- Less noisy
                                useParameterNames = true
                            },
                            maxLength = 25,
                            parameterHints = {
                                enable = true
                            },
                            reborrowHints = {
                                enable = "never" -- Less noisy
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
            },
            tools = {
                hover_actions = {
                    auto_focus = true
                },
                float_win_config = {
                    border = "rounded"
                }
            }
        }
    end
}
