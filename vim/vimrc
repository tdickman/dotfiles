" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

" Plugins
Plug 'https://github.com/vim-scripts/Conque-Shell.git'
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'https://github.com/Xuyuanp/nerdtree-git-plugin.git'
Plug 'https://github.com/vim-syntastic/syntastic.git'
Plug 'git://github.com/tpope/vim-fugitive.git'
Plug 'git://github.com/airblade/vim-gitgutter.git'
Plug 'https://github.com/elzr/vim-json.git'
Plug 'https://github.com/jistr/vim-nerdtree-tabs.git'
Plug 'https://github.com/christoomey/vim-tmux-navigator.git'

call plug#end()

" Fugitive
call pathogen#infect()
call pathogen#helptags()

set shiftwidth=4
set ts=4
set expandtab
set term=builtin_ansi

filetype plugin indent on
syntax on
set background=dark
colorscheme monokai
let mapleader = ','

" Nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

map <C-n> :NERDTreeToggle<CR>
map <Leader>n <plug>NERDTreeTabsToggle<CR>

let g:nerdtree_tabs_open_on_console_startup=1

set statusline=%f\ %{fugitive#statusline()}
set mouse=a
set ttymouse=xterm2
set number
let NERDTreeIgnore = ['__pycache__', '\.pyc$']
set splitright
set clipboard=unnamed

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

" Blank current pane
command B bp|sp|bn|bd

" Syntastic python3
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_python_python_exec = '/Library/Frameworks/Python.framework/Versions/3.5/bin/python3'
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_args='--ignore=E501,E225'

" Allow swapping of panes via ,mw and ,pw
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf 
endfunction

map <leader>mw :call MarkWindowSwap()<CR>
map <leader>pw :call DoWindowSwap()<CR>

command Term ConqueTerm bash
set backspace=indent,eol,start
set nowrap

" Remap control-w-j moves to control-j
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Fix weird colorness in vim when using tmux
set t_ut=

" Make mouse work properly beyond column 220
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end
