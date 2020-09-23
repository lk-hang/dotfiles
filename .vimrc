	" All commands below are results from this link
": //learnvimscriptthehardway.stevelosh.com
" Link: additional resources 
" https://www.reddit.com/r/vim/comments/8gmmk3/how_to_continue_to_improve_at_vim/
" A little test

" General basic settings -------------------- {{{
set nocompatible        		" use vim instead of vi 
syntax on               		" turn syntax highlighting on by default
filetype on             		" detect type of file
filetype indent on      		" load indent file for specific file type
filetype plugin on 				" load plugin file for specific file type

set visualbell t_vb=    		" turn off error beep/flash
set novisualbell        		" turn off visual bell

set number relativenumber       " show line numbers

set tabstop=4					" tab is four spaces
set shiftwidth=4				" manual indents are 4 spaces

" set timeoutlen=2000 			" Vim waits 2 seconds after pressing <Leader>
set backspace=indent,eol,start 	" allow backspacing over autoindent, line breaks, and 
								" start of insert.
set mouse=a						" enable scrolling with the mouse 
" disable pasting with middle mouse button
:map <MiddleMouse> <Nop>
:imap <MiddleMouse> <Nop>
" }}}}

" Tabline settings --------------------  {{{
set showtabline=2				" always show tabline


" Example from help
function MyTabLine()
	let s = ''
	for i in range(tabpagenr('$'))

		" select the highlighting
		if i + 1 == tabpagenr()
		  let s .= '%#TabLineSel#'
		else
		  let s .= '%#TabLine#'
		endif

		" set the tab page number (for mouse clicks)
		let s .= '%' . (i + 1) . 'T'

		" the label is made by MyTabLabel()
		let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
	endfor

	" after the last tab fill with TabLineFill and reset tab page nr
	let s .= '%#TabLineFill#%T'

	" right-align the label to close the current tab page
	if tabpagenr('$') > 1
		let s .= '%=%#TabLine#%999Xclose'
	endif

	return s
endfunction

function MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	return bufname(buflist[winnr - 1])
endfunction

set tabline=%!MyTabLine()
set tabline=
" }}}

" Search settings -------------------- {{{
set hlsearch            		" highlight searches
set incsearch           		" do incremental searching
set ignorecase          		" ignore case when searching
set smartcase           		" no ignorecase if Uppercase char present
" }}}

" Folding Settings -------------------- {{{
set foldcolumn=4
let foldcolor=238
execute "highlight folded ctermbg=".(238)
execute "highlight foldcolumn ctermbg=".foldcolor
set foldmethod=syntax
" }}}

" Windows Terminal settings --------------------  {{{
if &term =~ '^xterm'
	set t_u7=					" Fix for bug for entering replace mode at random
	" set noesckeys				" Another fix for the random replace mode bug

	" Cursor in terminal:
	" Link: https://vim.fandom.com/wiki/Configuring_the_cursor
	" 1 or 0 -> blinking block
	" 2 solid block
	" 3 -> blinking underscore
	" 4 solid underscore
	" Recent versions of xterm (282 or above) also support
	" 5 -> blinking vertical bar
	" 6 -> solid vertical bar

	" normal mode
	let &t_EI .= "\<Esc>[0 q" 	" blinking block
	" insert mode
	let &t_SI .= "\<Esc>[5 q"	" solid vertical bar

	augroup windows_term
		autocmd!
		autocmd VimEnter * silent !echo -ne "\e[0 q"
		autocmd VimLeave * silent !echo -ne "\e[6 q"
	augroup END
endif
" }}}



" Custom Key mappings -------------------- {{{
let mapleader = '\'
let maplocalleader = ','

" Move line up or down
noremap <leader>_ ddkP
noremap <leader>- ddp

" Alt escape binding (others are <c-c> or <c-[>)
inoremap jk <esc>

" Match trailing white spaces
" nnoremap <leader>w :match Error /\v\s+$/ <cr>
" nnoremap <leader>W :match none <cr>
" A little exercise with :execute command
nnoremap <silent> <leader>w :execute ":silent normal! :match Error " . '/\v\s+$/' . "\<lt>cr>"<cr>
nnoremap <silent> <leader>W :execute ":silent normal! :match none \<lt>cr>" <cr>

" Search automatically with very magic on
nnoremap / /\v
nnoremap ? ?\v
nnoremap <silent> <leader>noh :noh<cr>

" Search for WORD under cursor in current dir
" :nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:redraw!<cr>:copen 8<cr>

" Navigating in cwindow
nnoremap <leader>n :cnext<cr>
nnoremap <leader>N :cprevious<cr>
nnoremap <leader>cw :cclose<cr>

" Quick access to .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Make upper case
" inoremap <leader><c-u> <esc>viwUea
nnoremap <leader><c-u> viwUe

" Replace text
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
vnoremap <leader>' <esc>`<i'<esc>`>a'<esc>
vnoremap <leader>" <esc>`<i"<esc>`>a"<esc>

" Indent and unindent
" nnoremap <Tab> V><esc>
" nnoremap <S-Tab> V<<esc>

" Open previous buffer in split
nnoremap <leader>bp :execute "rightbelow vsplit " . bufname("#") <cr>

" Change text inside (last or next)
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il[ :<c-u>normal! F]vi[<cr>
onoremap in[ :<c-u>normal! f[vi]<cr>
onoremap il@ :<c-u>execute "normal! ?@\r:nohlsearch\rBvt@"<cr>
onoremap in@ :<c-u>execute "normal! /@\r:nohlsearch\rBvt@"<cr>

" Abbreviations
iabbrev @@ luckien.hang@berkeley.edu
iabbrev ssig -- <cr>Luc Kien Hang<cr>luckien.hang@berkeley.edu
iabbrev ccright Copyright 2020 Luc Kien Hang, all rights reserved.
" }}}

" Exit settings -------------------- {{{
augroup vim_exit
	autocmd!
	autocmd VimLeave * :!clear
	" Clear screen after exiting vim 
	" autocmd VimLeave * :set t_te=
	autocmd VimLeave * :set t_te=^[[H^[2J
augroup END
" }}}

" Statusline settings -------------------- {{{
set laststatus=2			" always show statusline
set statusline=%f			" relative path
set statusline+=%m\  			" modified flag [+] if modified
set statusline+=-\ buffer:\ %n 		" buffer number
set statusline+=%= 		  	" switch to the right side
set statusline+=\ %y 			" file type in []
set statusline+=\ %4l\/%4L 		" linenumber/total number of lines
" set statusline+=\ [%P] 			" in percentage
set statusline+=\ [%2cc]			" column number
" }}}

" Filetype specific settings -------------------- {{{
" Vimscript file settings -------------------- {{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Markdown file settings -------------------- {{{
augroup filetype_md
	autocmd!
	autocmd FileType md onoremap ih :<c-u> execute "normal! ?^[-=][-=]\\+$\r:nohlsearch\rkvg_"<cr>
	autocmd FileType md onoremap ah :<c-u> execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>
augroup END
" }}}

" Python file settings -------------------- {{{
augroup filetype_python
	autocmd!
	autocmd FileType python inoremap <buffer> <c-_> <esc>m`I# <esc>``lla
	autocmd FileType python nnoremap <buffer> <c-_> m`I# <esc>``ll
	autocmd FileType python nnoremap <buffer> <c-u> m`0xx``hh
augroup END
" }}}

" HTML file settings -------------------- {{{
augroup filetype_html
	autocmd!
	autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
augroup END
" }}}
" }}}	

echo "Successfully (re)sourced vimrc >^.^<"

execute pathogen#infect()

