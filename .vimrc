" Enable pathogen
filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

" Remove vi compatibility
set nocompatible

" Prevent some security exploits
set modelines=0

" Set dark background
set bg=dark

" Set line numbering
set number

" Tabs settings
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab