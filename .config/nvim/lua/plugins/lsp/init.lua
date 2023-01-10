return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        bashls= {},
        clangd = {},
        cssls = {},
        dockerls = {},
        html = {},
        jsonls = {},
        gopls = {},
        graphql = {},
        marksman = {},
        rust_analyzer = {},
        pyright = {},
        ruff_lsp = {},
        sqls = {},
        svelte = {},
        terraformls = {},
        tailwindcss = {},
        tsserver = {},
        yamlls = {},
        taplo = {},
        sumneko_lua = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
      },
    },
    ---@param opts PluginLspOpts
    config = function(plugin, opts)
      if plugin.servers then
        require("lazyvim.util").deprecate("lspconfig.servers", "lspconfig.opts.servers")
      end
      if plugin.setup_server then
        require("lazyvim.util").deprecate("lspconfig.setup_server", "lspconfig.opts.setup[SERVER]")
      end

      -- setup formatting and keymaps
      require("lazyvim.util").on_attach(function(client, buffer)
        require("lazyvim.plugins.lsp.format").on_attach(client, buffer)
        require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      -- diagnostics
      for name, icon in pairs(require("lazyvim.config").icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      })

      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
      require("mason-lspconfig").setup_handlers({
        function(server)
          local server_opts = servers[server] or {}
          server_opts.capabilities = capabilities
          if opts.setup[server] then
            if opts.setup[server](server, server_opts) then
              return
            end
          elseif opts.setup["*"] then
            if opts.setup["*"](server, server_opts) then
              return
            end
          end
          require("lspconfig")[server].setup(server_opts)
        end,
      })
    end,
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.golangci_lint,
          nls.builtins.diagnostics.hadolint,
          nls.builtins.formatting.markdownlint,
          nls.builtins.formatting.prettier,
          nls.builtins.diagnostics.pylama,
          nls.builtins.formatting.isort,
          nls.builtins.code_actions.refactoring,
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.ruff,
          nls.builtins.formatting.black,
          nls.builtins.formatting.rustfmt,
          nls.builtins.formatting.terrafmt,
          nls.builtins.diagnostics.tfsec,
          nls.builtins.formatting.golines,
          nls.builtins.formatting.goimports,
        },
      }
    end,
  },

  -- cmdline tools and lsp servers
  {

    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "ruff",
        "golangci-lint",
        "hadolint",
        "markdownlint",
        "prettier",
        "pylama",
        "isort",
        "stylua",
        "black",
        "rustfmt",
        "terraform-ls",
        "goimports",
        "golines",
        "tflint",

      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(plugin, opts)
      if plugin.ensure_installed then
        require("lazyvim.util").deprecate("treesitter.ensure_installed", "treesitter.opts.ensure_installed")
      end
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },
}
