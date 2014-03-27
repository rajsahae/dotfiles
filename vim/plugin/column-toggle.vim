nnoremap <leader>F :call FoldColumnToggle()<cr>

function! FoldColumnToggle()
  if &foldcolumn
    setlocal foldcolumn=0
  else
    setlocal foldcolumn=5
  endif
endfunction
