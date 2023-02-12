-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = {
    noremap = true,
    silent = true,
}
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
local rt = require("rust-tools")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = {
	    noremap = true,
	    silent = true,
	    buffer = bufnr,
	}
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({
		    async = true,
		})
	end, bufopts)
end

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}
-- require('lspconfig')['pyright'].setup {
--     on_attach = on_attach,
--     flags = lsp_flags
-- }
-- require('lspconfig')['tsserver'].setup {
--     on_attach = on_attach,
--     flags = lsp_flags
-- }
-- require('lspconfig')['terraformls'].setup {
--     on_attach = on_attach,
--     flags = lsp_flags
-- }
-- require('lspconfig')['tflint'].setup {
--     on_attach = on_attach,
--     flags = lsp_flags
-- }
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
    ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "ruff",
        "golangci-lint",
        "hadolint",
        "markdownlint",
        "prettierd",
        "pylama",
        "isort",
        "black",
        "rustfmt",
        "terraform-ls",
        "goimports",
        "golines",
        "tflint",
        "bashls",
        "clangd",
        "cssls",
        "cssmodules_ls",
        "diagnosticls",
        "dockerls",
        "gopls",
        "golangci_lint_ls",
        "graphql",
        "html",
        "jsonls",
        "tsserver",
        "lua_ls",
        "pyright",
        "sqls",
        "svelte",
        "tailwindcss",
        "taplo",
        "terraformls",
        "tflint",
        "yamlls",
    },
})

local opts = {
    tools = {
        runnables = {
            use_telescope = true,
        },
        inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },
    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
}
require("rust-tools").setup(opts)
require("lsp_signature").setup({})
