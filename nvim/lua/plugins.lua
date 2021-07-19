vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function()
  -- Packer
	use {'wbthomason/packer.nvim'};
  -- Syntax Highlighting
  	use {'nvim-treesitter/nvim-treesitter', 
		run = ':TSUpdate'
  	};
  -- Utilities
	use {'lewis6991/gitsigns.nvim',
  		requires = {
    		'nvim-lua/plenary.nvim'
  	},
  	config = function()
    require('gitsigns').setup()
  	end
	}
	-- use {'hoob3rt/lualine.nvim'};
	use {'scrooloose/nerdcommenter'};
  	use {'glepnir/galaxyline.nvim'};
	use {'preservim/nerdtree'};
	use {'Xuyuanp/nerdtree-git-plugin'};
	use {'p00f/nvim-ts-rainbow'}
	use {'windwp/nvim-ts-autotag'};
	use {'windwp/nvim-autopairs'};
  -- LSP
	 use {'neoclide/coc.nvim'};
	 use {'dense-analysis/ale'};
	 use {'folke/lsp-colors.nvim'};
  -- Themes
  	use {'folke/tokyonight.nvim'};
	use {'kyazdani42/nvim-web-devicons'};
    use {"lukas-reineke/indent-blankline.nvim"};
	use {"ryanoasis/vim-devicons"};

  -- Development
  	use {'fatih/vim-go', run = ':GoUpdateBinaries'}
	use {'pangloss/vim-javascript'};


end)

