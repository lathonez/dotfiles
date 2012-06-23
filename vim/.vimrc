set autoindent
"set smartindent
filetype plugin indent on
syntax enable

set tabstop=4
set shiftwidth=4

set showmatch
set ruler
set incsearch

"set foldenable
"set foldmethod=marker
"set foldmarker={,}   " Fold C style code
"set foldlevel=100    " Don't autofold anything

"set case insensitive search
set ignorecase
nnoremap <F5> :set noignorecase<CR>
nnoremap <F6> :set ignorecase<CR>

"setup the status line to display filename etc
set statusline=%<%f\ %h%m%r%=%-14Y\ %-14{&ff}\ %-14.(%l,%c%V%)\ %P
set laststatus=2

"enable tab dots and trailing space notification
set list listchars=tab:.\ ,trail:$
	highlight SpecialKey ctermfg=DarkGray

"toggle the notification (linked on F4)
function! ToggleTabNotification()
	if !exists("g:ToggleTabEnabled")
		let g:ToggleTabEnabled = 1
		set listchars=tab:\ \ 
	else
		unlet g:ToggleTabEnabled
		set list listchars=tab:.\ ,trail:$
	endif
endfunction
nnoremap <silent> <F4> :call ToggleTabNotification()<CR>

"enable loading viewcvs to bring up this file (linked on F2)
nnoremap <silent> <F2> :!viewcvs %<CR>

"map tabs
nnoremap <silent> <F7> :tabp<CR>
nnoremap <silent> <F8> :tabn<CR>

"kristian's folding toggle function (linked on spacebar)
function! ToggleFold()
   if foldlevel('.') == 0
      " No fold exists at the current line,
      " so create a fold based on indentation

      let l_min = line('.')   " the current line number
      let l_max = line('$')   " the last line number
      let i_min = indent('.') " the indentation of the current line
      let l = l_min + 1

      " Search downward for the last line whose indentation > i_min
      while l <= l_max
         " if this line is not blank ...
         if strlen(getline(l)) > 0 && getline(l) !~ '^\s*$'
            if indent(l) <= i_min
               " we've gone too far
               let l = l - 1    " backtrack one line
               break
            endif
         endif
         let l = l + 1
      endwhile

      " Clamp l to the last line
      if l > l_max
         let l = l_max
      endif

      " Backtrack to the last non-blank line
      while l > l_min
         if strlen(getline(l)) > 0 && getline(l) !~ '^\s*$'
            break
         endif
         let l = l - 1
      endwhile

      "execute "normal i" . l_min . "," . l . " fold"   " print debug info

      if l > l_min
         " Create the fold from l_min to l
         execute l_min . "," . l . " fold"
      endif
   else
      " Delete the fold on the current line
      normal zd
   endif
endfunction

nmap <space> :call ToggleFold()<CR>


" Syntastic Options
let g:syntastic_quiet_warnings=1

set path=**;.
