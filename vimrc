"Enable Vundle for plugin management.
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'fatih/vim-go'
Plugin 'majutsushi/tagbar'
Plugin 'fatih/molokai'
Plugin 'Valloric/YouCompleteMe'
" IMPORTANT NOTE: nsf/gocode is what does the autocompletion.
Plugin 'nsf/gocode', {'rtp': 'vim/'}

" For Git
Plugin 'tpope/vim-fugitive'

" Track the engine.
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
call vundle#end()
filetype plugin indent on
"Ok. Done.

let g:molokai_original=1
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0
let g:go_fmt_command = "goimports"
set tabstop=2
set shiftwidth=2
set autoindent
set ignorecase
set smartcase
set number
set ruler
syntax on
set backspace=indent,eol,start

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-h>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-m>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"if exists ("g:did_load_filetypes")
" filetype off
" filetype plugin indent off
"endif
"set runtimepath+=/usr/local/go/misc/vim
"filetype plugin indent on

"autocmd FileType go autocmd BufWritePre <buffer> Fmt
"highlight Pmenu ctermfg=White ctermbg=Black
"highlight PmenuSel ctermfg=Blue

" Open file at a position where it was last left.
au BufWinLeave *.go mkview
au BufWinEnter *.go silent loadview

