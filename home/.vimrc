set relativenumber

" Expand tab to 4 spaces
set expandtab
set tabstop=4

" Clear search buffer on return
nnoremap <silent> <CR> :let @/ = ""<CR><CR>

" Don't yank on d
nnoremap d "_d
vnoremap d "_d

