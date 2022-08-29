" Enable syntax highlighting
"syntax on

" Disable compatibility with vi which can cause unexpected issues

set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use

filetype on

" Enable plugins and load plugin for the detected fiel type

filetype plugin on

" Load an indent file for the detected file type

filetype indent on

" Add numbers to each line on the left-hand side

set relativenumber number

" Highlight cursor line underneath the cursor horizontally

set cursorline

" Option for vim windowing

set hidden

" Set shift width

set shiftwidth=4

" Set tab width

set tabstop=3

" Highlight search

set incsearch

" Case insensitive

set ignorecase

" Disable scratch preview on autocomplete

set completeopt-=preview

" Replace grep with ripgrep inside vim

set grepprg=rg\ --vimgrep\ --smart-case\ --follow


" Plugins via vim-plug

call plug#begin()

Plug 'junegunn/fzf.vim'  " For syntax highlighting when using fzf 'bat' has to be installed
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  " Fuzzy finder
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --clangd-completer' }  " Syntax completion
Plug 'sheerun/vim-polyglot'  " Syntax highlighting
Plug 'vim-airline/vim-airline'  " Fancy status bar 
Plug 'vim-airline/vim-airline-themes'  " Themes for vim-airline
Plug 'preservim/nerdtree'  " File explorer for vim

call plug#end()


" Airline settings

let g:airline#extensions#tabline#enabled=1
let g:airline_theme='luna'
let g:airline_powerline_fonts=1
set t_Co=256

" Bracket management

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
