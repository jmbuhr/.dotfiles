
vim.cmd [[
filetype plugin on
filetype indent on

au FocusGained,BufEnter * checktime
syntax enable

augroup filetypedetect
  au! BufRead,BufNewFile *.qmd setfiletype markdown
augroup END

augroup Terminal
  autocmd!
  au TermOpen * set nonu
augroup end
]]

