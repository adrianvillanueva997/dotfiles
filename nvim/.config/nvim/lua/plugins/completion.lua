return {{
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "onsails/lspkind.nvim",
        "petertriho/cmp-git",
        "hrsh7th/cmp-emoji",
        "saecki/crates.nvim",
        "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            completion = { completeopt = "menu,menuone,preview,noselect" },
            snippet = {
                expand = function(args) luasnip.lsp_expand(args.body) end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
                { name = "git" },
                { name = "emoji" },
                { name = "crates" },
                { name = "nvim_lsp_signature_help" },
            }),
            formatting = {
                format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }),
            },
            performance = {
                max_view_entries = 15, -- restrict displayed items
            },
        })
    end,
}}
