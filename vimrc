set nocompatible
" 开启语法高亮
"syntax

filetype plugin indent on
" 检测文件类型
filetype on
" 针对不同的文件类型采用不同的缩进格式
filetype indent on
filetype plugin on
" 启动自动补全
filetype plugin indent on

" 文件修改之后自动载入
set autoread
" 取消备份。视情况自己改
set nobackup
" 突出显示当前行等
set cursorcolumn
" 突出显示当前行
set cursorline
" 设置 退出vim后，内容在终端屏幕，可以用于查看和复制
" 好处：误删除什么的，如果以前屏幕打开，可以找回
set t_ti= t_te=

"==========================================
" Display Settings 展示/排版等截面格式设置
"==========================================

" 显示当前的行号列号
set ruler
" 在状态栏显示正在输入的命令
set showmode
" 在上下移动光标时，光标的上方或下方至少会保留显示的行数
set scrolloff=5

" 显示行号
set number

" 命令行（在状态行下）的高度，默认为1，这里是2
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
" Always show the status line - use 2 lines for the status bar
set laststatus=2

" 括号配对情况，跳转并高亮一下匹配的括号
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

" 设置文内智能搜索提示
" 高亮search命中的文本
set hlsearch
" 打开增量搜索模式，随着键入即时搜索
set incsearch
" 搜索时忽略大小写
set ignorecase
" 有一个或以上大写字母时仍大小写敏感
set smartcase  "ignore case if search pattern is all lowercase.

 
"==========================================
" FileEncode Setting 文件编码，格式 
"==========================================
" 设置新文件的编码为 UTF-8
set encoding=utf-8
" 自动判断编码时，依次尝试以下编码：
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set helplang=cn
set langmenu=zh_CN.UTF-8
set enc=2byte-gb18030
" 下面这句只影响普通模式（非图形界面）下的vim。
set termencoding=utf-8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" 如遇Unicode值大于255的文本，不必等到空格再拆行。
set formatoptions+=m
" 合并两行中文时，不在中间加空格：
set formatoptions+=B


"==========================================
" 其它设置 
"==========================================
" 自动补全配置
" 让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt=longest,menu
" 增强模式中的命令行自动完成操作
set wildmenu
" Ignore compiled files
set wildignore=*.o,*.d,*~,*.pyc,*.class,*.swp,*.bak

" 定义函数AutoSetFileHead, 自动插入文件头
autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"
function! AutoSetFileHead()
        " 如果文件类型为.sh文件
        if &filetype == 'sh'
                call setline(1, "\#!/bin/bash")
        endif

        " 如果文件类型为python
        if &filetype == 'python'
                call setline(1, "\#!/usr/bin/env python")
                call append(1, "\# encoding: utf-8")
        endif

        normal G
        normal o
        normal o
endfunction
	
" Autorinfo
let g:vimrc_autohor="chan fisher"
let g:vimrc_email="chanfisher@163.com"
let g:vimrc_homepage=" "
nmap <F5> :AuthorInfoDectect<CR>

" for taglist
let Tlist_Auto_Open=1
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_Left_Window=1
let Tlist_Auto_Update=1
let Tlist_WinHeight=10
let Tlist_WinWidth=38

if has("cscope")
   set csprg=/usr/bin/cscope
   set csto=1
   set cst

   set nocsverb
    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif

" function
function! UpdateCtags()
        let curdir=getcwd()
        while !filereadable("./tags")
                cd ..
                if getcwd() == "/"
                        break
                endif
        endwhile
        if filewritable("./tags")
                !ctags -R --file-scope=yes --langmap=c:+.h --languages=c,c++ --links=yes --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q
                TlistUpdate
        endif
        while !filereadable("./cscope.out")
                cd ..
                if getcwd()=="/"
                        break
                endif
        endwhile
        if filewritable("./cscope.out")
                !cscope -Rbq
                cs reset
        endif
        execute ":cd" . curdir
endfunction

" key map
nmap <F7> :TlistToggle<CR>
nmap <F8> :call UpdateCtags()<CR>

"Nerdtree
let g:NERDTreeWinPos="left"
let g:NERDTreeDirArrows=0
let g:NERDTreeWinSize=38
"let g:NERDTreeShowLineNumbers=1
"autocmd vimenter * NERDTree | wincmd w | wincmd l
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif
nmap <F6> :NERDTreeToggle<CR>

" neocomplcache
let g:neocomplcache_enable_at_startup = 1

" strip space at tails
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
function! StripTrailingWhitespace()
        if !&binary && &filetype != 'diff'
                normal mz
                normal Hmy
                %s/\s\+$//e
                normal 'yz<CR>
                normal `z
        endif
endfunction

autocmd FileType c,cpp source ~/.vimrc4c
autocmd FileType python source ~/.vimrc4py
autocmd FileType sh source ~/.vimrc4sh

" open file and local the cursor at the last edit line
autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
