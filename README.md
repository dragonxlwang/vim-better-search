# vim-better-search
The following keymap were added:

- &lt;C-L&gt;: Use to clear the highlighting and redraw
- space: Clear search history
- *: Visual mode pressing * searches for the current selection afterward
- #: Visual mode pressing # searches for the current selection backword
- &lt;leader&gt;gvc: Vimgrep visual-selected in current file
- &lt;leader&gt;gvd: Vimgrep visual-selected in project directory
- &lt;leader&gt;g: Vimgrep in project directory
- &lt;leader&gt;&lt;space&gt;: Vimgreps in the current file
- &lt;leader&gt;r: Search and replace the selected text
- &lt;leader&gt;cc, &lt;leader&gt;co: Open quickfix window (in a new tab)
- Qflen: Command to show total number of matches in quickfix (matches, errors)
- z/: Highlight all instances of word under cursor

issues it tries to resolve:
- automatic highlight current word
- vimgrep current selection in file/project with expected highlight
- */# search current word or visual selection
- redraw and remove highlight
- current match highlighted different from others
