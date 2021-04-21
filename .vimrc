set nu 

" c completion
" Avoid freezing on offending code
let g:clang_user_options='|| exit 0'
let g:clang_close_preview=1
let g:clang_complete_copen=1
let g:clang_hl_errors=1
let g:clang_debug=1
" Extra clang config
let g:clang_periodic_quickfix=1
let g:clang_snippets_engine=1

"background
set background=dark
"set background=light

"
filetype indent on
filetype plugin indent on

"ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

"let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabDefaultCompletionType = "context"

"search first in current directory then file directory for tag file
set tags=tags;/tags

"search text options
set hls
set incsearch
"set ignorecase

"Map spell check
map <F4> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>

"Change tab settings
set tabstop=4
set shiftwidth=4
set expandtab

" find using native vim grep (C code)
com -nargs=1 Psearch vimgrep <args> **/*.c **/*.h

"spelllang
nmap <F3> :setlocal spell spelllang=es<CR>
nmap <F4> :setlocal spell spelllang=en<CR>
nmap <F2> :set nospell<CR>

"ConqueGDB arm
let g:ConqueGdb_GdbExe = '/usr/local/bin/arm-none-eabi-gdb'

"Doxygen Syntax
let g:load_doxygen_syntax=1
"Doxygen doc
let g:DoxygenToolkit_briefTag_pre="@brief"
let g:DoxygenToolkit_paramTag_pre="@param "
let g:DoxygenToolkit_returnTag="@returns   "
"let g:DoxygenToolkit_blockHeader="-------------------------------"
"let g:DoxygenToolkit_blockFooter="---------------------------------"
let g:DoxygenToolkit_authorName="flopez"
let g:DoxygenToolkit_licenseTag="""\<enter>"

"Config clipboard
:set clipboard=unnamed 
:set clipboard=unnamedplus

"Auto header gates
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  
  execute "normal! o#ifdef __cplusplus"
  execute "normal! oextern \"C\" {"
  execute "normal! o#endif" 

  execute "normal! o#ifdef __cplusplus"
  execute "normal! o}" 
  execute "normal! o#endif" 

  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hh} call <SID>insert_gates()

"headers in .h
let g:C_SourceCodeExtensions  = 'h cc cp cxx cpp CPP c++ C i ii'

"netrw (default file explorer) --> like nerdtree
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
"augroup ProjectDrawer
"    autocmd!
"    autocmd VimEnter * :Vexplore
"augroup END

"hex conversion
"toHex -> %!xxd 
"toBin -> %!xxd -r

"kernel Hacking
"" 80 characters line
"set colorcolumn=81
""execute "set colorcolumn=" . join(range(81,335), ',')
"highlight ColorColumn ctermbg=Black ctermfg=DarkRed
"" Highlight trailing spaces
"" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
"highlight ExtraWhitespace ctermbg=red guibg=red
"match ExtraWhitespace /\s\+$/
"autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
"autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
"autocmd InsertLeave * match ExtraWhitespace /\s\+$/
"autocmd BufWinLeave * call clearmatches()

"linuxty.vim (Linux coding style pluging)
"Set apply directories (force only above dirs)
let g:linuxsty_patterns = [ "/usr/src/", "/linux", "/home/flopez_nbck/tmp/linux", "~/prj/usb2mdio/linux_drivers" ]
