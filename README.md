# vim-better-search
The following keymap were added:

- <C-L>: Use to clear the highlighting and redraw
- space: Clear search history
- *: Visual mode pressing * searches for the current selection afterward
- #: Visual mode pressing # searches for the current selection backword
- <leader>gvc: Vimgrep visual-selected in current file
- <leader>gvd: Vimgrep visual-selected in project directory
- <leader>g: Vimgrep in project directory
- <leader><space>: Vimgreps in the current file
- <leader>r: Search and replace the selected text
- <leader>cc, <leader>co: Open quickfix window (in a new tab)
- Qflen: Command to show total number of matches in quickfix (matches, errors)
- z/: Highlight all instances of word under cursor

issues it tries to resolve:
- automatic highlight current word
- vimgrep current selection in file/project with expected highlight
- */# search current word or visual selection
- redraw and remove highlight
- current match highlighted different from others
