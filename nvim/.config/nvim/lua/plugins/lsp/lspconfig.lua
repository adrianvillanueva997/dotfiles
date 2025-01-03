return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        {
            "antosha417/nvim-lsp-file-operations",
            config = true,
        },
        {
            "lvimuser/lsp-inlayhints.nvim",
            config = function()
                require("lsp-inlayhints").setup({
                    inlay_hints = {
                        parameter_hints = { show = true },
                        type_hints = { show = true },
                    },
                })
            end,
        },
        { "folke/trouble.nvim" },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local keymap = vim.keymap.set

        local opts = { noremap = true, silent = true }
        local on_attach = function(client, bufnr)
            opts.buffer = bufnr
            require("lsp-inlayhints").on_attach(client, bufnr)

            local mappings = {
                ["gR"] = { "<cmd>Telescope lsp_references<CR>", "Show LSP references" },
                ["gD"] = { vim.lsp.buf.declaration, "Go to declaration" },
                ["gd"] = { "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions" },
                ["gi"] = { "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations" },
                ["gt"] = { "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions" },
                ["<leader>ca"] = { vim.lsp.buf.code_action, "See available code actions" },
                ["<leader>rn"] = { vim.lsp.buf.rename, "Smart rename" },
                ["<leader>D"] = { "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics" },
                ["<leader>d"] = { vim.diagnostic.open_float, "Show line diagnostics" },
                ["[d"] = { vim.diagnostic.goto_prev, "Go to previous diagnostic" },
                ["]d"] = { vim.diagnostic.goto_next, "Go to next diagnostic" },
                ["K"] = { vim.lsp.buf.hover, "Show documentation for what is under cursor" },
                ["<leader>rs"] = { ":LspRestart<CR>", "Restart LSP" },
            }

            for k, v in pairs(mappings) do
                opts.desc = v[2]
                keymap("n", k, v[1], opts)
            end
        end

        local capabilities = cmp_nvim_lsp.default_capabilities()

        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        local servers = {
            "html", "ts_ls", "cssls", "tailwindcss", "terraformls", "pyright", "ruff", "lua_ls"
        }

        for _, lsp in ipairs(servers) do
            lspconfig[lsp].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
        end

        lspconfig["rust_analyzer"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = { diagnostics = { enable = true } },
        })

        lspconfig["svelte"].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePost", {
                    pattern = { "*.js", "*.ts" },
                    callback = function(ctx)
                        if client.name == "svelte" then
                            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
                        end
                    end,
                })
            end,
        })

        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })
    end,
}
