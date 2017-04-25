set nocompatible               " be iMproved
 filetype off                   " required!

 set rtp+=~/.vim/bundle/vundle/
 call vundle#rc()

 " let Vundle manage Vundle
 " required! 
 Bundle 'gmarik/vundle'

 " My Bundles here:
 "
 " original repos on github
Bundle 'scrooloose/nerdtree'
Bundle 'winmanager' 
Bundle 'fholgado/minibufexpl.vim'
Bundle "ctrlpvim/ctrlp.vim"
Bundle "'mileszs/ack.vim'"
"Bundle "xolox/vim-lua-ftplugin"
Bundle "xolox/vim-misc"

let g:ackprg = 'ag --nogroup --nocolor --column'

" vim-scripts repos
 " non github repos
 " git repos on your local machine (ie. when working on your own plugin)
 " ...

 filetype plugin indent on     " required!
 "
 " Brief help
 " :BundleList          - list configured bundles
 " :BundleInstall(!)    - install(update) bundles
 " :BundleSearch(!) foo - search(or refresh cache first) for foo
 " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
 "
 " see :h vundle for more details or wiki for FAQ
 " NOTE: comments after Bundle command are not allowed..
 " NERDTree config
map <F2> :NERDTreeToggle<CR>

let g:miniBufExplMapWindowNavVim    = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs  = 1
let g:miniBufExplModSelTarget       = 1
"解决FileExplorer窗口变小问题
"let g:miniBufExplForceSyntaxEnable = 1
"let g:miniBufExplorerMoreThanOne=2
"let g:miniBufExplCycleArround=1
"" buffer 切换快捷键，默认方向键左右可以切换buffer
map <C-Tab> :MBEbn<cr>
map <C-S-Tab> :MBEbp<cr>

let Tlist_Sort_TypDTreeHighlightCursorline=1
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.obj$', '\.o$', '\.so$', '\.egg$', '^\.git$', '^\.svn$', '^\.hg$' ]
let g:netrw_home='~/bak'
"close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | end

let g:ctrlp_map = '<leader>p'
let g:ctrlp_cmd = 'CtrlP'
map <leader>f :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
    \ }
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1

set ambiwidth=double
set ci
set encoding=utf-8
"tab宽度为4空格
set tabstop=4
set shiftwidth=4
"将所有tab替换为空格
set expandtab
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$,nbsp:` 
set list
syntax on
autocmd FileType c set tabstop=2|set shiftwidth=2

set noswapfile
