"-------------------------Vundle-------------------------------------
set nocompatible              " 去除VI一致性,必须
filetype off                  " 必须
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/vundle' 
"Plugin 'L9'
"Plugin 'FuzzyFinder'
"Plugin 'nerdcommenter'
"Plugin 'https://github.com/scrooloose/nerdcommenter.git'
Plugin 'scrooloose/nerdcommenter'
Plugin 'a.vim'
"Plugin 'matchparen'
Plugin 'EdTsft/matchparen'
"Plugin 'vimplugin/project.vim'
"Plugin 'spellfile'
"Plugin 'zipPlugin'
"Plugin 'bookmarking'
"Plugin 'dterei/VimBookmarking'
"Plugin 'getscriptPlugin'
Plugin 'minibufexpl.vim'
Plugin 'python_fold'
Plugin 'taglist.vim'
Plugin 'DoxygenToolKit.vim'
Plugin 'grep.vim'
"Plugin 'tarPlugin'
Plugin 'echofunc.vim'
"Plugin 'gzip'
"Plugin 'nerd_tree'
Plugin 'The-NERD-tree'
"Plugin 'rrhelper'
"Plugin 'tohtml'
Plugin 'filetype.vim'
"Plugin 'netrwPlugin'
"Plugin 'snipMate'
Plugin 'msanders/snipmate.vim'
"Plugin 'vimballPlugin'
Plugin 'vim-utils/vim-man'
Plugin 'Omnicppcomplete'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tacahiroy/ctrlp-funky' 
Plugin 'yianwillis/vimcdoc'
call vundle#end()
"-------------------------Vundle-------------------------------------

filetype plugin indent on
syntax on
set nocompatible
set backspace=indent,eol,start
set backspace=2
set syn=cpp
set cindent
set smartindent
set showmatch
set autoindent
set number
set tabstop=4
set shiftwidth=4
"warp是自动换行
"set nowrap
set incsearch
set hlsearch
set nobackup
set t_Co=256

"主题眼色
colorscheme termcolor

set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
set fileformats=unix
set fileformat=unix

"总是显示状态行
set laststatus=2

"设置命令行高毒
set cmdheight=2

"设置状态行内容
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [%{&encoding}]\ [%{&fileencoding}]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}

"光标移动到buffer顶部和底部所保持的距离
set scrolloff=3

"高亮当前行
set cursorline
hi cursorline term=none cterm=none ctermbg=240



",gb2312,gbk,big5

"helptags ~/.vim/doc

"filetype plugin indent on
if has("autocmd")
	au! BufRead,BufNewFile *.proto setfiletype proto
	au! BufNewFile *h,*cpp exec "DoxAuthor"
	au! BufReadPost changelog :call SetFlod() | exe "normal! zM" | nmap <buffer> <CR> za
	au! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"zz" | endif
	au! FileType cpp,c,h,php :call CppCodeDeyMap()
	au! FileType proto :call SetFlod()
	au! FileType python setlocal et sta sw=4 sts=4
endif

function! SetFlod()
	setlocal foldenable foldmethod=marker foldmarker={,} commentstring=%s
endfunction


function! CppCodeDeyMap()
	"imap <silent><leader>if<Tab> <ESC>:call InsertTemplate('if')<CR>
	"imap <silent><leader>ie<Tab> <ESC>:call InsertTemplate('ifelse')<CR>
	"imap <silent><leader>fo<Tab> <ESC>:call InsertTemplate('for')<CR>
	"imap <silent><leader>sw<Tab> <ESC>:call InsertTemplate('switch')<CR>
	"imap <silent><leader>wh<Tab> <ESC>:call InsertTemplate('while')<CR>
	"imap <silent><leader>wd<Tab> <ESC>:call InsertTemplate('whiledo')<CR>
	"imap <silent><leader>dw<Tab> <ESC>:call InsertTemplate('dowhile')<CR>
	"imap <silent><leader>cl<Tab> <ESC>:call InsertTemplate('class')<CR>

	"imap <silent><leader>st<Tab> struct<Space>
	"imap <silent><leader>un<Tab> unsigned<Space>
	"imap <silent><leader>#i<Tab> #include<Space>
	"imap <silent><leader>#d<Tab> #define<Space>

	"ino <leader>{<CR>	{};<Left><Left><CR><ESC>ko
	"ino {<CR>			{};<Left><CR><ESC>ko
	"ino [				[];<Left>
	"ino "				"";<Left>
	"ino '				'';<Left>
	"ino ::				::<C-X><C-O>

	"imap 			<ESC>

	"新开窗口显示
	nmap 				<C-W>
	imap 				<ESC><C-W>
endfunction

function! Help()
	if &buftype == 'help'
		quit
	else
		if &filetype == 'cpp' || &filetype == 'h' || &filetype == 'c'
			silent! exec 'h xie'
		else
			silent! exec 'help'
		endif
	endif
endfunction

function! FindQuickFixWindow()
	let win_count = winnr('$')
	let i = 0
	let quickfix_win = -1
	while i < win_count
		if getbufvar(winbufnr(i + 1), '&buftype') == 'quickfix'
			let quickfix_win = i + 1
			break
		endif
		let i = i + 1
	endwhile
	return quickfix_win
endfunction

function! QuickFix()
	if FindQuickFixWindow() == -1
		exec 'botright copen'
	else
		exec 'ccl'
	endif
endfunction


function! InsertTemplate(type)
	let code = ''
	let cur_line = line('.')
	let cur_col = col('.')
	let put_line = cur_line - 1
	let offset_x = 0
	let offset_y = 0
	if a:type == 'if'
		let code = 'if () {\n\t\n}'
		let offset_x = 4
	elseif a:type == 'ifelse'
		let code = 'if() {\n\t\n} else {\n\t\n}'
		let offset_x = 4
	elseif a:type == 'for'
		let code = 'for () {\n\t\n}'
		let offset_x = 5
	elseif a:type == 'switch'
		let code = 'switch () {\ncase 1:\nbreak;\ncase 2:\nbreak;\ndefault:\nbreak;\n}'
		let offset_x = 8
	elseif a:type == 'while'
		let code == 'while () {\n\t\n}'
		let offset_x = 7
	elseif a:type== 'whiledo'
		let code == 'while () {\n\t\n} do ()'
		let offset_x = 7
	elseif a:type == 'dowhile'
		let code == 'do () {\n\t\n} while ()'
		let offset_x = 4
	elseif a:type == 'class'
		let clname = input('Enter your class name: ')
		let code = 'class' .clname. '\n{\nprivate:\n\nprotected:\n\npublic:\n'.clname.'();\nvirtual ~'.clname.'();\n}'
		let offset_x=4
		let offset_y=3
	endif

	exec put_line . 'put = \"'.code.'\"'
	let n = line('.') - cur_line + 1
	call cursor(cur_line,cur_col)
	exec 'normal! '. n . '=='
	call cursor(cur_line + offset_y, col(',') + offset_x)
	star
endfunction

if !exists(':W')
	command! W w
endif

if !exists(':Q')
	command! Q q
endif


nmap <PAGEUP>				<C-B>
nmap <PAGEDOWN>				<C-F>
imap <PAGEUP>				<ESC><C-B>i
imap <PAGEDOWN>				<ESC><C-F>i

imap <C-E>					<ESC><C-E>a
imap <C-Y>					<ESC><C-Y>a
nmap <BS>					<C-W>h
nmap <F10>					#:%s/<C-R>=expand("<cword>")<CR>//g<left><left>
imap <F10>					<ESC><F10>
nmap <silent><F11>			:nohl<CR>
imap <silent><F11>			<ESC>:nohl<CR>a
"nmap <silent><Space>		i<Space><ESC>i
"nmap <silent><F1>			:call Help()<CR>
"imap <silent><F1>			<ESC>:call Help()<CR>
"vmap <silent><F1>			:call Help()<CR>


nmap K :Man <C-R>=expand("<cword>")<CR><CR>

set tabpagemax=50

"F8 快速替换
nmap <F8>	<ESC>:%s/\r\n/\r/g<CR><ESC>:w<CR><ESC>:%s/\r/\r/g<CR><ESC>:w<CR>

"F1 开开当前目录文件
nmap <F1>			:o .<CR>

"F2 新建buffer 列出当前目录文件
nmap <F2> :tabnew .<CR>

"左右选择buffer
nmap <M-L> gt
nmap <M-H> gT

"Project相关
let g:proj_flags="imstg"
let g:proj_close_fold_onstart=1

"自动补全相关
set completeopt=longest,menu
imap <silent><C-/>	<C-X><C-O>

map <leader><F3> :ToggleBookmark<CR>
map <leader><F4> :PreviousBookmark<CR>
map <leader><F5> :NextBookmark<CR>

"F3 Grep 全文搜索相关
let Grep_Xargs_Options = '-0'	"这行只在mac os x 上适用
let Grep_Default_Filelist = '*.c *.cpp *.mm *.h'
nmap <silent><F3> :Rgrep<CR><CR><CR><CR>
imap <silent><F3> <ESC><F3>

"F4 代码折叠
set foldmethod=syntax
set foldlevel=100		"启动vim是不要自动折叠代码
"nmap <silent><F4> za
"imap <silent><F4> <ESC><F3>

"F4 vimgrep快速搜索
"vmap <silent><F4>	:vim /\<<C-R><C-W>\>/ **/*<CR>
"nmap <silent><F4>	:vim /<C-R>0/ **/*<CR>
"nmap <silent><F4>	:tab vs<CR>



"F9 QuickFix 相关
nmap <silent><F9>	:call QuickFix()<CR>
imap <silent><F9>	<ESC><F9>
"nmap <silent><C-X><C-K>		:cp<CR>
"imap <silent><C-X><C-K>		<ESC>:cp<CR>
"nmap <silent><C-X><C-J>		:cn<CR>
"imap <silent><C-X><C-J>		<ESC>:cn<CR>
"nmap <silent><M-J>		:cn<CR>zz
"nmap <silent><M-K>		:cp<CR>zz
"nmap <silent>j 		:cn<CR>zz
"nmap <silent>k 		:cp<CR>zz
nmap <silent><C-J>		:cn<CR>zz
nmap <silent><C-K> 		:cp<CR>zz

"nmap<F12>	gg=G
nmap <C-c>		yaw


"=====================================================================
"	buffer 切换
"Ctrl+X Ctrl+D 关闭一个tab
"cmd: b 数字 切换到指定编号的buffer
"=====================================================================
"GUI模式下有序tab键切换
let g:miniBufExplMapCTabSwitchBufs=1
"Ctrl+hjkl在窗口间切换
"let g:miniBufExplMapWindowNavVim=1
nmap <silent><C-X><C-D>	:bd<CR>
imap <silent><C-X><C-D>	<ESC><C-X><C-D>
nmap <silent><C-H>	:bp<CR>
nmap <silent><C-L>	:bn<CR>



"====================================================
"	注释相关
"====================================================
let g:DoxygenToolkit_briefTag_pre="@brief\t"
let g:DoxygenToolkit_paramTag_pre="@Param\t"
let g:DoxygenToolkit_returnTag="@Returns\t"
let g:DoxygenToolkit_blockHeader="---------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="---------------------------------------------------------"
let g:DoxygenToolkit_authorName=""
let g:DoxygenToolkit_briefTag_funcName="no"
let g:DoxygenToolkit_undocTag="DOXIGEN_SKIP_BLOCK"
"let g:DoxygenToolkit_licenseTag="My own license"	<-- !!! Does not end with "\<enter>"



"====================================================
"	F5 打开或关闭 Tlist
"====================================================
let Tlist_Show_One_File=1
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_Highlight_Tag_On_BufEnter=1
let Tlist_Auto_Highlight_Tag=1
let Tlist_auto_Update=1
let Tlist_WinWidth=60
nmap tt :Tlist<CR>

"====================================================
"	Crtl+A 切换cpp,h
"====================================================
nmap <silent><C-A>	:A<CR>
imap <silent><C-A>	<ESC><C-A>
nmap <silent><C-A><C-S>	:AS<CR>
imap <silent><C-A><C-S>	<ESC>:AS<CR>
nmap <silent><C-A><C-V>	:AV<CR>
imap <silent><C-A><C-V>	<ESC>:AV<CR>


"map ,,	:FufCoverageFile<CR>
"let g:fuf_coveragefile_globPatterns = ['**/*.h', '**/*.c', '**/*.cpp', '**/*.cc', '**/*.mm', '**/*.m', '**/*.xml', '**/*.py', '**/*.proto', '**/*.gdb']

map ,, :CtrlP ./<CR>
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:40,results:40'
let g:ctrlp_by_filename = 1
let g:ctrlp_cache_dir = $HOME.'.cache/ctrlp'
let g:ctrlp_max_files = 10000
let g:ctrlp_max_depth = 40
let g:ctrlp_max_history = &history
let g:ctrlp_mruf_max = 250
"let g:ctrlp_lazy_update = 1

"vimgdb相关
run macros/gdb_mappings.vim	
syntax enable			" enable syntax highlighting

"====================================================
"	cscope ctag 相关
"====================================================

set tags+=~/.vim/gcc.tags

if has("cscope")

	"csto选项决定是先查找tag文件还是先查找cscope数据库
	"设置为0则先查找cscope数据库，设置为1先查找tag文件
	set csto=1

	"设定是否使用quickfix窗口来显示cscope的结果
	set cscopequickfix=c-,d-,e-,g-,i-,s-,t-

	"接管ctags的 Ctrl+] 于 Ctrl+T,若不想接管则设置 set nocst
	set cst

	"查找光标所在位置的 C 符号（可以跳过注释）
	nmap <silent><C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><C-@>s <Esc><C-@>s

	"查找光标所在位置的变量和函数的定义
	nmap <silent><C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><C-@>g <Esc><C-@>g

	"查找所有调用了贯标所在位置的变量或函数的地方
	nmap <silent><C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><C-@>c <Esc><C-@>c

	"查找光标所在位置的字符串
	nmap <silent><C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><C-@>t <Esc><C-@>t

	"查找光标所在位置的单词 egrep 模式
	nmap <silent><C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><C-@>e <Esc><C-@>e

	"查找 本文件
	nmap <silent><C-@>f :cs find f <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><C-@>f <Esc><C-@>f

	"查找包含本文件的文件
	nmap <silent><C-@>i :cs find i <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><C-@>i <Esc><C-@>i

	"查找本函数调用的函数
	nmap <silent><C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><C-@>d <Esc><C-@>d

endif
