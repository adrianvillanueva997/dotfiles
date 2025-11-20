return {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
    dependencies = {"mason-org/mason.nvim"},
    config = function()
        local mason_registry = require("mason-registry")

        local adapter

        vim.g.rustaceanvim = {
            dap = {
                adapter = adapter
            },
            server = {
                default_settings = {
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
            }
        }
    end
}
