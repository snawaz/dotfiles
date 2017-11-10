"
" nvim/init.vim
"

" General options
set cursorline
set fillchars+=vert:\│
set hidden
set hlsearch
set laststatus=2
set noshowmode
set number

if &filetype == "rust"
    set colorcolumn=100
else
    set colorcolumn=80
endif

" Backup options
set backup
set backupdir=~/.local/share/nvim/backup
set undofile

" Indentation options
set tabstop=4
set shiftwidth=4
set expandtab

" Color options
set t_Co=256
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai
syntax on

" Allow transparent background
hi Normal ctermbg=NONE
hi NonText ctermbg=NONE

" Install plugins
call plug#begin()

Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'itchyny/lightline.vim'
Plug 'neomake/neomake'
Plug 'rust-lang/rust.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neoinclude.vim'
Plug 'tikhomirov/vim-glsl', { 'for': 'glsl' }
Plug 'timonv/vim-cargo', { 'for': 'rust' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'zchee/deoplete-clang'

call plug#end()

" Javacomplete2 configuration
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" let g:racer_cmd = $HOME . "/.cargo/bin/racer"
" let g:racer_experimental_completer = 1

" Language server configuration
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
\}

" Deoplete configuration (needs `clang`)
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#clang_header = '/usr/lib64/clang'
let g:deoplete#sources#clang#libclang_path = '/usr/lib64/libclang.so'
let g:deoplete#sources#rust#racer_binary = $HOME . '/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path = $RUST_SRC_PATH

" Lightline configuration (requires Powerline-patched font)
let g:lightline = {
    \ 'colorscheme': 'powerline',
    \ 'active': {
    \     'left': [['mode', 'paste'],
    \              ['fugitive', 'filename']],
    \     'right': [['neomake', 'lineinfo'],
    \               ['percent'],
    \               ['fileformat', 'fileencoding', 'filetype']]
    \ },
    \ 'component': {
    \     'lineinfo': ' %3l:%-2v'
    \ },
    \ 'component_function': {
    \     'fugitive': 'MyFugitive',
    \     'readonly': 'MyReadonly',
    \     'modified': 'MyModified',
    \     'filename': 'MyFilename'
    \ },
    \ 'component_expand': {
    \     'neomake': 'neomake#statusline#LoclistStatus'
    \ },
    \ 'component_type': {
    \     'neomake': 'error'
    \ },
    \ 'separator': {
    \     'left': '', 'right': ''
    \ },
    \ 'subseparator': {
    \     'left': '', 'right': ''
    \ }
\}

function! MyFilename()
    return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyModified()
    if &filetype == "help"
        return ""
    elseif &modified
        return "+"
    elseif &modifiable
        return ""
    else
        return ""
    endif
endfunction

function! MyReadonly()
    return &readonly ? '' : ''
endfunction

" Integrate Fugitive into Lightline
function! MyFugitive()
    if exists("*fugitive#head")
        let _ = fugitive#head()
        return strlen(_) ? ' '._ : ''
    endif
    return ''
endfunction

" Integrate Syntastic into Lightline
autocmd User NeomakeFinished | call lightline#update()

augroup AutoNeomake
    autocmd!
    autocmd BufWritePost *.* Neomake
augroup end
