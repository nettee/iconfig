set nocompatible             " 关闭Vi兼容
set backspace=2              " 设置退格键可用
set number                   " 显示行号
set mouse=a                  " 启用鼠标
set ruler                    " 右下角显示光标位置的状态行
set showcmd                  " 标尺的右边显示未完成的命令
colorscheme default

set autoindent               " 新行使用与前一行一样的缩进
set smartindent              " 智能自动缩进
set shiftwidth=4             " 4格缩进,  > 缩进4格
set tabstop=4                " 设置Tab键的宽度,4个空格
set softtabstop=4            " 设置Tab键的缩进量
" 建议将下行改为文件格式判断后再自动转化
set expandtab                " 将Tab自动转化成空格 

set history=100              " 保存100个命令和100个查找模式的历史

" below are vundle required
" filetype off
" set rtp+=~/.vim/bundle/vundle/
" call vundel#rc()
" " let Vundle manage Vundle
" Bundle 'gmarik/vundle'
" Bundle 'vim-plugin-foo'
" Bundel 'vim-plugin-bar'


set incsearch                " 开启实时搜索功能
set hlsearch                 " 开启高亮显示结果
set nowrapscan               " 搜索到文件两端时不重新搜索
set ignorecase smartcase     " 查找时输入小写字母，则大小写不敏感，输入大写字母，则大小写敏感
" 可以在查找的内容前加 "\C" 临时改为大小写敏感
set vb t_vb=                 " 关闭提示音 [会闪屏]
set hidden                   " 允许在有未保存的修改时切换缓冲区
set autochdir                " 设定文件浏览器目录为当前目录
set foldmethod=syntax        " 选择代码折叠类型
set foldlevel=100            " 禁止自动折叠
set laststatus=2             " 开启状态栏信息
set showmatch                " 显示括号配对情况
"set cursorline              " 突出显示当前行
"set nowrap                  " 设置不自动换行
set writebackup              " 设置无备份文件
set nobackup
set list                     " 显示Tab符，使用一高亮竖线代替
set listchars=tab:\|\ ,

au BufEnter /home/william/NEMU/* setlocal tags+=/home/william/NEMU/tags


map! <C-F> <Esc>gUiw`]a

syntax enable                " 打开语法高亮
syntax on                    " 开启文件类型侦测
filetype indent on           " 针对不同的文件类型采用不同的缩进格式
filetype plugin on           " 针对不同的文件类型加载对应的插件
filetype plugin indent on    " 启用自动补全

"set filetype=python
au BufNewFile,BufRead *.py,*.pyw setf python



" 每行超过80个的字符用下划线标示
au BufRead,BufNewFile *.c,*.h,*.rb,*.js,*.coffee,*.sql,*.sh,*.vim,*.css,*.html 2match Underlined /.\%81v/


" 设置编码
set fenc=utf-8
set encoding=utf-8
set fileencodings=utf-8,gbk,cp936,latin-1



" 快捷键 
" Ctrl + H            将光标移到当前行的行首
imap <c-h> <ESC>I
" Ctrl + J            
imap <c-j> <ESC>ja
" Ctrl + K           
imap <c-k> <ESC>ka
" Ctrl + L            将光标移到当前行的行尾
imap <c-l> <ESC>A

" C/C++ 代码注释掉
noremap + :s#^#//#<CR> :nohl<CR>
noremap - :s#^//##<CR> :nohl<CR>

" 保存当前文件并留在插入模式       [Insert]
 imap ;w <ESC>:w<CR>li
" 返回Normal模式，不执行保存       [Insert]
 imap ;k <ESC>
" Paste from * 
map <Ins> "*p


imap ;cm int<SPACE>main()<CR>{<CR><ESC>I<CR><CR>}<ESC>ka<TAB>return<SPACE>0;<ESC>ka<TAB>
imap ;cia #include<SPACE><stdio.h><CR>#include<SPACE><stdlib.h><CR>#include<SPACE><string.h><CR>#include<SPACE><math.h>
imap ;cio #include<SPACE><stdio.h><CR>
imap ;cis #include<SPACE><string.h><CR>
imap ;cd #define<SPACE>


imap ;ti #!/usr/bin/python3.2<CR><CR>
imap ;d std::
