" Copyright (C) 2016 Xiaolong Wang  <dragonxlwang@gmail.com>
" Part of the file was ripped from:
" https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup
" https://github.com/amix/vimrc
" https://github.com/tpope/vim-sensible
" And some useful discussion
" http://stackoverflow.com/questions/3765798/
"   vim-search-and-highlighting-control-from-a-script

" =============================- Keymap: Search -===============================

" <C-L>: Use to clear the highlighting and redraw
" space: Clear search history
" *: Visual mode pressing * searches for the current selection afterward
" #: Visual mode pressing # searches for the current selection backword
" <leader>gvf: Vimgrep visual-selected in current file
" <leader>gvd: Vimgrep visual-selected in project directory
" <leader>gf : Vimgrep in current file
" <leader>gd : Vimgrep in project directory
" <leader>r: Search and replace the selected text
" <leader>cc, <leader>co: Open quickfix window (in a new tab)
" Qflen: Command to show total number of matches in quickfix (matches, errors)
" z/: Highlight all instances of word under cursor
" <leader>rr : Forward (with loop) substitution

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :call ColorOff() \| :call clearmatches() \|
        \ :call MultipleHighlightOff() \| :noh \| :ccl
        \<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif
" nnoremap <silent> <space> :call clearmatches() \| :set nornu \| :noh \|
"       \call ColorOff() \| ccl<CR><ESC>
nnoremap <silent> <space> :call ColorOff() \| :call clearmatches() \|
      \ :call MultipleHighlightOff() \| :noh \|
      \ :if exists("g:indentLine_loaded")<Bar>IndentLinesEnable<Bar>endif<CR> \|
      \ :setlocal rnu \| :setlocal nocuc \|
      \ :ccl<CR><ESC>
vnoremap <silent> * :call VisualSelection('f')<CR>:set hls<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>:set hls<CR>
vnoremap <leader>gvf :call VisualSelection('gvf')<BAR>set hls<CR>
vnoremap <leader>gvd :call VisualSelection('gvd')<BAR>set hls<CR>
command! -nargs=* VimgrepIn :call VimgrepSelection(<f-args>)<BAR>set hls
nnoremap <leader>gf :VimgrepIn //g %<left><left><left><left>
nnoremap <leader>gd :VimgrepIn //g **/*.
      \<left><left><left><left><left><left><left><left>
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>
" noremap <leader>cc :call CopenToggle()<CR>
noremap <leader>cc :setlocal ignorecase! \| echoe "ignorecase =" &ignorecase<CR>
noremap <leader>co ggVGy:tabnew<CR>:set syntax=qf<CR>pgg
command! QfLen :echo 'Total number of items: ' len(getqflist())
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
" nmap zh *``
" nnoremap zj :call matchadd('IncSearch', '\c\<<C-R>=expand("<cword>")<CR>\>')<CR>
" nnoremap zh :let @/='\c\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>:echo @/<CR>
nnoremap zh :call MultipleHighlightOff()<CR>:call MultipleHighlightAdd()<CR>
      \ :set hls<CR>:echo @/<CR>
nnoremap zl :call MultipleHighlightAdd()<CR>:set hls<CR>:echo @/<CR>
" vnoremap zh :call VisualHighlightToggle()<Bar>set hls<CR>:echo @/<CR>
vnoremap zh :call MultipleHighlightOff()<CR>:call MultipleHighlightAddVisual()<CR>
      \ :set hls<CR>:echo @/<CR>
vnoremap zl :call MultipleHighlightAddVisual()<Bar>:set hls<CR>:echo @/<CR>
" Forward (with loop) substitution
nnoremap <leader>rr :,$s//gc<BAR>1,''-&&<home><right><right><right><right>
" Highlight current match different from others
nnoremap <silent> <leader>n :cn<CR>:call HLNext()<CR>:set hls<CR>
nnoremap <silent> <leader>N :cp<CR>:call HLNext()<CR>:set hls<CR>
nnoremap <silent> n :call HLNext()<CR>n
nnoremap <silent> N :call HLNext()<CR>N
nnoremap <unique> / :call HLNextSetTrigger()<CR>/
nnoremap <unique> ? :call HLNextSetTrigger()<CR>?
nnoremap <unique> * :call HLNextSetTrigger()<CR>*
nnoremap <unique> # :call HLNextSetTrigger()<CR>#

nnoremap zhh :call MultipleHighlightOff()<CR>:call ShiftLastHighlightWord(1)<CR>
      \ :set hls<CR>:echo @/<CR>
nnoremap zhl :call MultipleHighlightOff()<CR>:call ShiftLastHighlightWord(0)<CR>
      \ :set hls<CR>:echo @/<CR>

function! ShiftLastHighlightWord(is_left)
  call MultipleHighlightInit()
  if a:is_left
    let s:last_search = s:last_search[1:]
  else
    let s:last_search = s:last_search[:-2]
  endif
  let g:multiple_highlight_list += [s:last_search]
  let @/='\c\('.join(g:multiple_highlight_list, '\|').'\)'
endfunction


function! MultipleHighlightAdd()
  call MultipleHighlightInit()
  let s:last_search = expand("<cword>")
  let g:multiple_highlight_list += ['\<'.s:last_search.'\>']
  let @/='\c\('.join(g:multiple_highlight_list, '\|').'\)'
endfunction

function! MultipleHighlightAddVisual() range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  call MultipleHighlightInit()
  let g:multiple_highlight_list += [l:pattern]
  let @/='\c\('.join(g:multiple_highlight_list, '\|').'\)'
  let @" = l:saved_reg
endfunction

function! MultipleHighlightOff()
  if exists('g:multiple_highlight_list')
    unlet g:multiple_highlight_list
  endif
endfunction

function! MultipleHighlightInit()
  if !exists('g:multiple_highlight_list')
    let g:multiple_highlight_list = []
  endif
endfunction

function! CopenToggle()
  let l:c = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
  silent! cclose
  if l:c == len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    execute "silent! copen "
  endif
endfunction

function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VimgrepSelection(pattern, scope)
  execute "vimgrep " . a:pattern . " " . a:scope
  botright cw
  wincmd p
  call HLNextSetTrigger()
  let l:pattern = substitute(a:pattern, "^/", "", "")
  let l:pattern = substitute(l:pattern, "/.*$", "", "")
  let @/ = l:pattern
endfunction

function! VisualSelection(cmd) range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  if a:cmd == 'gvf'
    call CmdLine("vimgrep " . '/'. l:pattern . '/g' . ' %')
    " Without the next line, you would have to hit ENTER,
    " even if what is written (the questions) has no interest:
    call feedkeys(" ")
    botright cw
    wincmd p
  elseif a:cmd == 'gvd'
    call CmdLine("vimgrep " . '/'. l:pattern . '/g' . ' **/*.')
    call feedkeys(" ")
    botright cw
    wincmd p
  elseif a:cmd == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '//gc<left><left><left>')
  elseif a:cmd == 'f'
    execute "normal /" . l:pattern . "\<CR>"
  elseif a:cmd == 'b'
    execute "normal ?" . l:pattern . "\<CR>"
  endif
  call HLNextSetTrigger()
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime&
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

function! VisualHighlightToggle() range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  call HLNextSetTrigger()
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Damian-Conway-s-Vim-Setup/blob/master/plugin/hlnext.vim
function! HLNext ()
  call HLNextOff()
  let target_pat = '\c\%#\%('.@/.'\)'
  " let @/ = '\c'.@/
  let w:HLNext_matchnum = matchadd('IncSearch', target_pat)
  redraw!
endfunction
" Clear previous highlighting (if any)...
function! HLNextOff ()
  if exists('w:HLNext_matchnum')
    try
      call matchdelete(w:HLNext_matchnum)
    endtry
    unlet w:HLNext_matchnum
  endif
endfunction
" Prepare to active next-match highlighting after cursor moves...
function! HLNextSetTrigger ()
  augroup HLNext
    autocmd!
    autocmd  CursorMoved  *  :call HLNextMovedTrigger()
  augroup END
endfunction
" Highlight and then remove activation of next-match highlighting...
function! HLNextMovedTrigger ()
  au! HLNext
  " comment out or otherwise W19 is raised, which occurs after patch 7.4-2196
  " augroup! HLNext
  call HLNext()
endfunction

function! ColorOff()
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime&
    echo 'Highlight current word: off'
    return 0
  endif
  call HLNextOff()
  redraw!
endfunction
