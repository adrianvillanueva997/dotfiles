"== Plugins ==
call plug#begin('~/.vim/plugged')
" Color schemes
Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'
"Visual stuff
Plug 'ryanoasis/vim-devicons'
Plug 'glepnir/spaceline.vim'
Plug 'leafgarland/typescript-vim'
Plug 'luochen1990/rainbow'
Plug 'ap/vim-css-color'
"Productivity
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'} ":CocInstall coc-json coc-html coc-tsserver
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'unkiwii/vim-nerdtree-sync'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
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

"""" enable 24bit true color
" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
 set termguicolors
endif
syntax enable

autocmd FileType scss setl iskeyword+=@-@
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
  \ 'coc-json', 'coc-go', 'coc-tsserver']
nn <silent> I :call CocActionAsync('doHover')<cr>
nmap <silent> <Leader>cm :call CocActionAsync<cr>
nmap <silent> <leader>cf <Plug>(coc-fix-current)
nmap <silent> <Leader>cd <Plug>(coc-definition)
nmap <silent> <Leader>cy <Plug>(coc-type-definition)
nmap <silent> <Leader>ci <Plug>(coc-implementation)
nmap <silent> <Leader>cr <Plug>(coc-references)
nmap <silent> <Leader>cn <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>cp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>cm <Plug>(coc-rename)
nmap <silent> <Leader>gp :GFiles<CR>
inoremap <silent><expr> <c-space> coc#refresh()

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" ALE
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'

"Rainbow
let g:rainbow_active = 1

"Prettier
