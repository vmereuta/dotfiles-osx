" ──────────────────────────────────────────────────────────────
" Vim Configuration - Modern minimal setup
" For heavy editing use nvim; this is for quick terminal edits
" ──────────────────────────────────────────────────────────────

set nocompatible
filetype plugin indent on
syntax on

" ── Appearance ──
set background=dark
set number
set relativenumber
set cursorline
set signcolumn=yes
set laststatus=2
set showmode
set showcmd
set ruler
set title
set shortmess=atI
set scrolloff=8
set sidescrolloff=8

" Status line (no plugins needed)
set statusline=%f\ %m%r%h%w\ %=%y\ [%l/%L,\ %c]\ %p%%

" ── Encoding ──
set encoding=utf-8
set fileencoding=utf-8

" ── Indentation ──
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set autoindent
set smartindent

" ── Search ──
set hlsearch
set incsearch
set ignorecase
set smartcase

" ── Editing ──
set backspace=indent,eol,start
set clipboard=unnamed,unnamedplus
set mouse=a
set wildmenu
set wildmode=longest:full,full
set completeopt=menuone,noselect

" ── Performance ──
set ttyfast
set lazyredraw
set updatetime=250

" ── Files ──
set nobackup
set nowritebackup
set noswapfile
set undofile
set undodir=~/.vim/undo
set autoread

" ── Splits ──
set splitbelow
set splitright

" ── Key mappings ──
let mapleader=","

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Clear search highlights
nnoremap <leader><space> :nohlsearch<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines up/down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep cursor centered when scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Strip trailing whitespace
noremap <leader>ss :%s/\s\+$//e<CR>

" Save as root
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" ── Autocmds ──
if has("autocmd")
    " Treat .json files as JSON
    autocmd BufNewFile,BufRead *.json setfiletype json syntax=json
    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
    " Return to last edit position
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    " Remove trailing whitespace on save
    autocmd BufWritePre * :%s/\s\+$//e
endif
