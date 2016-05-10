"dein Scripts-----------------------------
if &compatible
  set nocompatible
endif

" Required:
set runtimepath^=~/.vim/dein.vim/repos/github.com/Shougo/dein.vim

let s:dein_dir = expand('~/.vim/dein.vim')
if isdirectory(s:dein_dir)
  " Required:
  call dein#begin(s:dein_dir)
  
  " Let dein manage dein
  " Required:
  call dein#add('Shougo/dein.vim')
  
  " Add or remove your plugins here:
  call dein#add('Shougo/neocomplete.vim')
  call dein#add('alpaca-tc/vim-endwise')
  call dein#add('Shougo/vimshell')
  call dein#add('fatih/vim-go')
  
  " Required:
  call dein#end()
  
  " Required:
  filetype plugin indent on
  
  if dein#check_install()
    call dein#install()
  endif
endif
"End dein Scripts-------------------------

syntax enable
set nu
set autoindent
set tabstop=4
set shiftwidth=4
set noexpandtab
set softtabstop=0
set incsearch
set backspace=indent,eol,start
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
