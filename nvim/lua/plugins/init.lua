return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  
  use {"folke/which-key.nvim"}
  use {'nvim-treesitter/nvim-treesitter',run=":TSUpdate"} 
  use {'windwp/nvim-ts-autotag'}
  use {'p00f/nvim-ts-rainbow'}


  use {'hoob3rt/lualine.nvim', requires={'kyazdani42/nvim-web-devicons', opt=true}}
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  
  use {'kyazdani42/nvim-tree.lua',  requires = 'kyazdani42/nvim-web-devicons'}


end)

