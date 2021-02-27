"== plugins ==
call plug#begin('~/.vim/plugged')
" Color schemes
Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'sickill/vim-monokai'
"Visual stuff
Plug 'ryanoasis/vim-devicons'
Plug 'glepnir/spaceline.vim'
Plug 'leafgarland/typescript-vim'
Plug 'luochen1990/rainbow'
Plug 'ap/vim-css-color'
"Productivity
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'} "Coc install stuff is in line 105
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'unkiwii/vim-nerdtree-sync'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'sheerun/vim-polyglot'

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
if (empty($TMUX))
  if (has("nvim"))    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

set conceallevel=1
syntax on
set nocompatible
colorscheme PaperColor
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

"NerdTree tweaks
let g:NERDTreeGitStatusUseNerdFonts = 1
map <F5> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

"Coc stuff
let g:coc_global_extensions = [
  \ 'coc-json', 'coc-go', 'coc-tsserver', 'coc-pyright']
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

"Rainbow
let g:rainbow_active = 1

"Vim-go syntax highlight
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

" onedark
"let g:onedark_terminal_italics = 1

"Python syntax highlight
let g:python_highlight_all = 1

"PaperColor
let g:allow_italic = 1
let g:allow_bold = 1
