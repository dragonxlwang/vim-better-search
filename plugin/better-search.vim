" Copyright (C) 2016 Xiaolong Wang  <dragonxlwang@gmail.com>
"
" Part of the file was ripped from:
" https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup
" https://github.com/amix/vimrc
" https://github.com/tpope/vim-sensible

" =============================- Keymap: Search -===============================

" <C-L>: Use to clear the highlighting and redraw
" space: Clear search history
" *: Visual mode pressing * searches for the current selection afterward
" #: Visual mode pressing # searches for the current selection backword
" <leader>gvf: Vimgrep visual-selected in current file
" <leader>gvd: Vimgrep visual-selected in project directory
" <leader>gf : Vimgrep in current file
" <leader>gd : Vimgrep in project directory
" <leader><space>: Vimgreps in the current file
" <leader>r: Search and replace the selected text
" <leader>cc, <leader>co: Open quickfix window (in a new tab)
" Qflen: Command to show total number of matches in quickfix (matches, errors)
" z/: Highlight all instances of word under cursor

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch \| call ColorOff() \| ccl
        \<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif
nnoremap <space> :noh \| call ColorOff() \| ccl<CR><ESC>
vnoremap <silent> * :<C-u>call VisualSelection('')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('')<CR>?<C-R>=@/<CR><CR>
vnoremap gvf :call VisualSelection('gvf')<Bar>set hls<CR>
vnoremap gvd :call VisualSelection('gvd')<Bar>set hls<CR>
map <leader>gf :vimgrep // %<left><left><left>
map <leader>gd :vimgrep // **/*.<left><left><left><left><left><left><left>
map <leader><space>
      \ :vimgrep // <C-R>%<C-A><Home><right><right><right><right>
      \<right><right><right><right><right>
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
command! QfLen :echo 'Total number of items: ' len(getqflist())
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
" Highlight current match different from others
nnoremap <silent> n n:call HLNext()<cr>
nnoremap <silent> N N:call HLNext()<cr>
nnoremap <silent> <leader>n :cn \| call HLNext() \| set hls<cr>
nnoremap <silent> <leader>N :cp \| call HLNext() \| set hls<cr>
nnoremap <unique> / :call HLNextSetTrigger()<CR>/
nnoremap <unique> ? :call HLNextSetTrigger()<CR>?

function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSelection(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  if a:direction == 'gvf'
    call CmdLine("vimgrep " . '/'. l:pattern . '/g' . ' %')
    " Without the next line, you would have to hit ENTER,
    " even if what is written (the questions) has no interest:
    call feedkeys(" ")
    botright cw
    wincmd p
  elseif a:direction == 'gvd'
    call CmdLine("vimgrep " . '/'. l:pattern . '/g' . ' **/*.')
    " Without the next line, you would have to hit ENTER,
    " even if what is written (the questions) has no interest:
    call feedkeys(" ")
    botright cw
    wincmd p
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
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

" Damian-Conway-s-Vim-Setup/blob/master/plugin/hlnext.vim
function! HLNext ()
  call HLNextOff()
  let target_pat = '\c\%#\%('.@/.'\)'
  let w:HLNext_matchnum = matchadd('MatchParen', target_pat)
  redraw
endfunction
" Clear previous highlighting (if any)...
function! HLNextOff ()
  if exists('w:HLNext_matchnum')
    call matchdelete(w:HLNext_matchnum)
    redraw
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
  augroup! HLNext
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
endfunction
