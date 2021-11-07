require'nvim-treesitter.configs'.setup {
  ensure_installed = {"javascript", "lua", "python", "rust", "typescript", "dockerfile", "go", "gomod", "graphql", "json", "toml", "hcl", "css", "bash" },
  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  autotag = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}
