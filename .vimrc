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

"
filetype indent on

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

"ctrlp plugins
set runtimepath^=~/.vim/bundle/ctrlp

"Map spell check
map <F4> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>

"Change tab settings
set tabstop=4
set shiftwidth=4
set expandtab

"Macro para los usuarios del repo en la migracion
let @q = 'yw€@7pi >€kl<@die.upm.esBByww€krP€kDI€kd'

"spelllang
nmap <F3> :setlocal spell spelllang=es<CR>
nmap <F4> :setlocal spell spelllang=en<CR>
nmap <F2> :set nospell<CR>

"ConqueGDB arm
let g:ConqueGdb_GdbExe = '/usr/local/bin/arm-none-eabi-gdb'

"Doxygen doc
let g:DoxygenToolkit_briefTag_pre="@Synopsis  "
let g:DoxygenToolkit_paramTag_pre="@Param "
let g:DoxygenToolkit_returnTag="@Returns   "
let g:DoxygenToolkit_blockHeader="-------------------------------"
let g:DoxygenToolkit_blockFooter="---------------------------------"
let g:DoxygenToolkit_authorName="flopez"
let g:DoxygenToolkit_licenseTag="""\<enter>"

"Find in Google
if $TERM =~ "xterm"

    vmap ?? y<Esc>:silent exec
                \ ":!/usr/bin/opera http://www.google.com/search?q='"
                \ . substitute(@","\\W\\+\\\\|\\<\\w\\>",'\\%20',"g")
                \ . "' &"<CR><CR>

else

    vmap ?? <Esc>:silent exec
                \ ":!start c:/opera/6/opera.exe http://www.google.com/search?q=\""
                \ . substitute(@*,"\\W\\+\\\\|\\<\\w\\>"," ","g")
                \ . "\""<CR><CR>

endif

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
