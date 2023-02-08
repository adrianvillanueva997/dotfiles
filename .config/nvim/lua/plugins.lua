-- This file can be loaded by calling `lua require('plugins')` from your
-- init.vim
-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")
    -- UI Stuff
    use({
        "lewis6991/gitsigns.nvim",
        requires = {"nvim-lua/plenary.nvim"},
        config = function()
            require("gitsigns").setup()
        end
    })
    use("nvim-tree/nvim-web-devicons")
    use({
        "nvim-lualine/lualine.nvim",
        requires = {
            "kyazdani42/nvim-web-devicons",
            opt = true
        }
    })
    use("lukas-reineke/indent-blankline.nvim")
    use({"rebelot/kanagawa.nvim"})
    -- Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            local ts_update = require("nvim-treesitter.install").update({
                with_sync = true
            })
            ts_update()
        end
    })
    use({"nvim-treesitter/nvim-treesitter-refactor"})
    use({"mrjones2014/nvim-ts-rainbow"})
    use({"nvim-treesitter/nvim-treesitter-context"})
    use({"JoosepAlviste/nvim-ts-context-commentstring"})

    -- lsp stuff
    use({"neovim/nvim-lspconfig"})
    use({"simrat39/rust-tools.nvim"})
    use({"williamboman/mason.nvim"})
    use({
        "saecki/crates.nvim",
        event = {"BufRead Cargo.toml"},
        requires = {{"nvim-lua/plenary.nvim"}},
        config = function()
            require("crates").setup()
        end
    })
    use({"ray-x/lsp_signature.nvim"})
    use({
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            require("lspsaga").setup({})
        end,
        requires = {{"nvim-tree/nvim-web-devicons"}}
    })

    -- completion
    use({"hrsh7th/nvim-cmp"})
    use({"hrsh7th/cmp-buffer"})
    use({"hrsh7th/cmp-nvim-lua"})
    use({"hrsh7th/cmp-nvim-lsp"})
    use({"hrsh7th/cmp-nvim-lsp-signature-help"})
    use({"hrsh7th/cmp-path"})
    use({"hrsh7th/cmp-emoji"})
    use({"L3MON4D3/LuaSnip"})
    use({"saadparwaiz1/cmp_luasnip"})
    use({"onsails/lspkind.nvim"})
    use({
        "ray-x/navigator.lua",
        requires = {{
            "ray-x/guihua.lua",
            run = "cd lua/fzy && make"
        }, {"neovim/nvim-lspconfig"}}
    })

    -- Debugging
    use({"nvim-lua/plenary.nvim"})
    use({"mfussenegger/nvim-dap"})

    -- utils
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end
    })

    use({
        "nvim-telescope/telescope.nvim",
        requires = {{"nvim-lua/plenary.nvim"}}
    })
    use({
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end
    })

    -- Lua
    use({
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end
    })

    -- linting
    use({"jose-elias-alvarez/null-ls.nvim"})
    use("lukas-reineke/lsp-format.nvim")
end)
