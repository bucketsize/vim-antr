command! -nargs=* Antr      call antr#Antr()

command! -nargs=* AntrBld   call SetBuilder( '<args>' )
command! -nargs=* AntrSet   call SetProject( '<args>' )
command! -nargs=* AntrNew   call CreateProject( '<args>' )
command! -nargs=* AntrCmp   call SetMakeAsAntCompile() | make | copen
command! -nargs=* AntrRun   call SetMakeAsAntRun()  | make | copen
command! -nargs=* AntrCmpRun   call SetMakeAsAntCompileRun()  | make | copen
command! -nargs=* AntrTest  call SetMakeAsAntTest() | make | copen
command! -nargs=* AntrClean  call SetMakeAsAntClean() | make | copen
command! -nargs=* AntrParseLibs  call ParseLibDirs()

map <F9>  :call SetMakeAsAntCompile()<CR>:make<CR>:copen<CR>
map <F11> :call SetMakeAsAntRun()<CR>:make<CR>:copen<CR>
map <F12> :call SetMakeAsAntRun()<CR>:make<CR>:copen<CR>

" this doesnt work??
"map <leader>AntRun  :call SetMakeAsAntRun()<CR>:make<CR>:copen<CR>
"map <leader>AntTest :call SetMakeAsAntTest()<CR>:make<CR>:copen<CR>

call antr#Antr()
