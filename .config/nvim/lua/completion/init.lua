-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require("lspconfig")

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {"bashls", "clangd", "cssls", "cssmodules_ls", "diagnosticls", "dockerls", "gopls", "golangci_lint_ls",
                 "graphql", "html", "jsonls", "tsserver", "sumneko_lua", "pyright", "sqls", "svelte", "tailwindcss",
                 "taplo", "terraformls", "tflint", "yamlls"}
local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150
}

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = require("lsp-format").on_attach,
        capabilities = capabilities,
        flags = lsp_flags
    })
end

-- luasnip setup
local luasnip = require("luasnip")

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    window = {
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered()
        }
    },

    formatting = {
        format = function(entry, vim_item)
            if vim.tbl_contains({"path"}, entry.source.name) then
                local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
                if icon then
                    vim_item.kind = icon
                    vim_item.kind_hl_group = hl_group
                    return vim_item
                end
            end
            return require("lspkind").cmp_format({
                with_text = false
            })(entry, vim_item)
        end
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
        ["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {"i", "s"})
    }),
    sources = {{
        name = "nvim_lsp"
        -- max_item_count = 6
    }, {
        name = "luasnip",
        option = {
            show_autosnippets = true
        }
    }, {
        name = "buffer"
    }, {
        name = "crates"
    }, {
        name = "nvim_lsp_signature_help"
    }, {
        name = "path"
    }}
})
