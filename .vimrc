"== plugins ==
call plug#begin('~/.vim/plugged')
" Color schemes
Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'ghifarit53/tokyonight-vim'

"Visual stuff
Plug 'ryanoasis/vim-devicons'
Plug 'glepnir/spaceline.vim'
Plug 'leafgarland/typescript-vim'
Plug 'luochen1990/rainbow'
Plug 'ap/vim-css-color'
Plug 'folke/lsp-colors.nvim'

"Productivity
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim', {'branch': 'release'} "Coc install stuff is in line 105
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'unkiwii/vim-nerdtree-sync'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'sheerun/vim-polyglot'
Plug 'kyazdani42/nvim-web-devicons'

"Programming language related
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'pangloss/vim-javascript'

"Linters
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less',
  \ 'scss', 'json', 'graphql', 'markdown', 'vue',
  \ 'yaml', 'html'] }

call plug#end()
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
set colorcolumn=110
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

"Panes tweaks
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"Spaceline tweaks
let g:spaceline_seperate_style = 'curve'
let g:spaceline_colorscheme = 'space'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:spaceline_seperate_style = 'none'
let g:spaceline_colorscheme = 'space'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:spaceline_diagnositc_tool = 'ale'
let g:spaceline_diff_tool = 'git-gutter'
let g:spaceline_git_branch_icon = ' '
let g:spaceline_diagnostic_errorsign = 'ﲅ'
let g:spaceline_diagnostic_warnsign = ' '
let g:spaceline_custom_diff_icon = ['+','=','-']
"NerdTree tweaks
let g:NERDTreeGitStatusUseNerdFonts = 1
map <silent> tt :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

"Coc stuff
let g:coc_global_extensions = [
  \ 'coc-json', 'coc-go', 'coc-tsserver', 'coc-pyright', 'coc-rust-analyzer']
nn <silent> q :call CocActionAsync('doHover')<cr>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gf <Plug>(coc-fix)

inoremap <silent><expr> <c-space> coc#refresh()

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" ALE
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let b:ale_fixers = {'javascript': ['prettier', 'eslint'], 'go':['gofmt', 'goimports'], 'vue':['prettier']}
let g:ale_fix_on_save = 1

"Rainbow
let g:rainbow_active = 1

"Vim-go syntax highlight
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

" onedark
let g:onedark_terminal_italics = 1

"Python syntax highlight
let g:python_highlight_all = 1

"PaperColor
let g:allow_italic = 1
let g:allow_bold = 1
