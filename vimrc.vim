execute pathogen#infect()

set noswapfile

" ********** Tree **********

" Shows hidden files

let NERDTreeShowHidden=1

" Open a NERDTree automatically when vim starts up

autocmd vimenter * NERDTree

" Close vim if the only window left open is a NERDTree

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" ********** Softwrap **********

" Switch wrap off for everything
set nowrap
 
if has("autocmd")
 
  " This is probably in your .vimrc already. No need to duplicate!
  filetype plugin indent on
 
  " Set File type to 'text' for files ending in .txt
  autocmd BufNewFile,BufRead *.txt setfiletype text
 
  " Enable soft-wrapping for text files
  autocmd FileType text,markdown,md setlocal wrap linebreak nolist
  
endif

" ********** Whitespace **********

" convert tabs to spaces
:set expandtab

" Highlight problematic whitespace
:set listchars=tab:>.,trail:.,extends:#,nbsp:.
:set list

" Detect file type for indentation below
:filetype indent on

" Use 2 space indentation on all files
:autocmd FileType * set ai sw=2 sts=2 et

" ********** Key Mapping **********

:let mapleader=" "
:map <Space> <PageDown>
:map <Leader>e :Explore<cr>
:map <Leader>v :vsplit<cr>
:map <Leader>s :split<cr>
:map <Leader>\ :NERDTreeToggle<cr>

" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" make C-c act like esc for stuff like :normal I
:inoremap <C-c> <esc>

" ********* Visual Styles ************

:set number " display row numbers
:set guioptions-=r  "remove right-hand scroll bar

:set guifont=Inconsolata:h18
colorscheme hybrid

" ********* Ack (Silver Searcher)************
:map <Leader>f :Ag<space>
let g:ackprg = 'ag --nogroup --nocolor --column'

" ********* ctrlp ************
:map <Leader>t :CtrlP<cr>
:map <silent><Leader>b :CtrlPBuffer<cr>

let g:path_to_matcher = "/usr/local/bin/matcher"

let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files . -co --exclude-standard']

let g:ctrlp_match_func = { 'match': 'GoodMatch' }

function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)

  " Create a cache file if not yet exists
  let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
  if !( filereadable(cachefile) && a:items == readfile(cachefile) )
    call writefile(a:items, cachefile)
  endif
  if !filereadable(cachefile)
    return []
  endif

  " a:mmode is currently ignored. In the future, we should probably do
  " something about that. the matcher behaves like "full-line".
  let cmd = g:path_to_matcher.' --limit '.a:limit.' --manifest '.cachefile.' '
  if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
    let cmd = cmd.'--no-dotfiles '
  endif
  let cmd = cmd.a:str

  return split(system(cmd), "\n")

endfunction

" Cucumber Plugin

filetype plugin indent on
