-- [[ plug.lua ]]

vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")
    use({
        "kyazdani42/nvim-tree.lua",
        requires = {
            "kyazdani42/nvim-web-devicons", -- optional, for file icons
        },
        tag = "nightly", -- optional, updated every week. (see issue #1193)
    })
    use("lewis6991/impatient.nvim")
    use({ "folke/which-key.nvim" })

    -- [[ Theme ]]
    use({ "mhinz/vim-startify" }) -- start screen
    use({ "DanilaMihailov/beacon.nvim" }) -- cursor jump
    use("olimorris/onedarkpro.nvim")
    use("folke/tokyonight.nvim")
    use({
        "nvim-lualine/lualine.nvim", -- statusline
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })

    -- [[ Dev ]]
    use({
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "jose-elias-alvarez/null-ls.nvim",
    })
    use({ "nvim-treesitter/nvim-treesitter" })
    use("nvim-treesitter/nvim-treesitter-context")
    use("p00f/nvim-ts-rainbow")
    use("windwp/nvim-ts-autotag")
    use("stsewd/sphinx.nvim")
    use({
        "nvim-telescope/telescope.nvim", -- fuzzy finder
        requires = { { "nvim-lua/plenary.nvim" } },
    })
    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    })
    use({ "Yggdroot/indentLine" }) -- see indentation
    use({ "tpope/vim-fugitive" }) -- git integration
    use({ "junegunn/gv.vim" }) -- commit history
    use({ "windwp/nvim-autopairs" }) -- auto close brackets, etc.

    use("voldikss/vim-floaterm")
    use("ray-x/guihua.lua")
    use("simrat39/rust-tools.nvim")
    use("ray-x/go.nvim")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lsp-signature-help")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-vsnip")
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/vim-vsnip")
    use("rafamadriz/friendly-snippets")
    use({
        "ThePrimeagen/refactoring.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" },
        },
    })
    use("weilbith/nvim-code-action-menu")
    use 'hrsh7th/cmp-nvim-lsp-document-symbol'
end)
