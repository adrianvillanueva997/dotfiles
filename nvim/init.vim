lua require('wrapper')

set termguicolors
set conceallevel=1
syntax on
set nocompatible
let g:tokyonight_style = "night"
let g:tokyonight_italic_functions = 1
colorscheme tokyonight

set background=dark
set number
set noswapfile
set mouse=a
set backspace=indent,eol,start
set modelines=5
set modeline
set laststatus=2
set textwidth=100
set wrapmargin=0
set formatoptions=cqt "tcron
set nowrap
set encoding=utf-8
set foldenable
set fdm=marker
set scrolloff=8
set sidescrolloff=15
set sidescroll=1
set nu
set rnu
set numberwidth=5
set tabstop=4
set shiftwidth=4
set noexpandtab
set smarttab
set cursorline
set autoindent
set smartindent
set cindent
set hlsearch
set incsearch
set ignorecase
set smartcase
set autoread " automatically reload files upon change outside VIM
set splitbelow
set splitright
" Use completion-nvim in every buffer

"Panes tweaks
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

nnoremap <C-T> :tabnew<CR>
nnoremap <C-Q> :tabclose<CR>

nnoremap <C-S> :sp<CR>
nnoremap <C-V> :vs<CR>

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
			  \ "go", "gomod" ,"css" , "javascript","graphql",
			  \ "html", "javascript","python", "rust", "scss", "vue", "yaml",
			  \ "typescript", "dockerfile", "json", "lua"},
  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
  },
}
EOF
"Coc stuff
let g:coc_global_extensions = [
  \ 'coc-json', 'coc-go', 'coc-tsserver', 'coc-pyright', 
  \ 'coc-rust-analyzer', 'coc-json', 'coc-html', 'coc-css',
  \ 'coc-markdownlint','coc-lua', 'coc-docker', 'coc-snippets', 
  \ 'coc-yaml', 'coc-vetur', 'coc-prisma', 'coc-pydocstring', ]
nn <silent> q :call CocActionAsync('doHover')<cr>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent>ff  <Plug>(coc-codeaction)

nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gf <Plug>(coc-fix)
" ALE Stuff (Only used for linting)
let b:ale_fixers = {
			\ 'javascript': ['prettier', 'eslint'], 
			\ 'go':['gofmt', 'goimports'], 
			\ 'vue':['prettier'], 
			\ 'python':['autoflake','autoimport','autopep8','black','isort','yapf'],
			\ 'lua':['luafmt', 'lua-format', 'stylua'],
			\ 'typescript': ['eslint', 'prettier','tslint']}
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 0

"NerdTree tweaks
let g:NERDTreeGitStatusUseNerdFonts = 1
map <silent> tt :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
