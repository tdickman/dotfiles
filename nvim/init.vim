call plug#begin()
  Plug 'preservim/nerdtree'
  Plug 'https://github.com/jistr/vim-nerdtree-tabs.git'
  Plug 'https://github.com/github/copilot.vim.git'
  Plug 'https://github.com/christoomey/vim-tmux-navigator.git'
  Plug 'https://github.com/davidhalter/jedi-vim.git'
  " https://www.reddit.com/r/vim/comments/7tt4ts/painless_copy_paste_between_tmux_vim_and_system/dtgwdbk/
  Plug 'tmux-plugins/vim-tmux-focus-events'
  Plug 'https://github.com/roxma/vim-tmux-clipboard.git'
call plug#end()

filetype plugin indent on
let mapleader = ','
set background=dark
colorscheme monokai

set mouse=a
set number
set clipboard=unnamedplus

" Nerdtree
let g:nerdtree_tabs_open_on_console_startup=1
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>
map <Leader>n <plug>NERDTreeTabsToggle<CR>

let g:copilot_filetypes = {
\    '*': v:false,
\    'python': v:true,
\}

" Put swapfiles in a central location
set swapfile
set dir=~/.tmp

" Remap control-w-j moves to control-j
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Map function keys to tabs
map <Esc>OP :tabn1<CR>
map <Esc>OQ :tabn2<CR>
map <Esc>OR :tabn3<CR>
map <Esc>OS :tabn4<CR>
map <Esc>[15~ :tabn5<CR>
map <Esc>[17~ :tabn6<CR>
map <Esc>[18~ :tabn7<CR>
map <Esc>[19~ :tabn8<CR>
map <Esc>[20~ :tabn9<CR>
map <Esc>[21~ :tabn10<CR>
map <Esc>[23~ :tabn11<CR>
map <Esc>[24~ :tabn12<CR>
map ¡ :tabmove 0<CR>
map ™ :tabmove 1<CR>
map £ :tabmove 2<CR>
map ¢ :tabmove 3<CR>

" By default use 4 spaces
set shiftwidth=4
set ts=4
set expandtab

" Use 2 spaces for html and js
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype scss setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sw=2 expandtab
autocmd Filetype vue setlocal ts=2 sw=2 expandtab
autocmd Filetype yaml setlocal ts=2 sw=2 expandtab
