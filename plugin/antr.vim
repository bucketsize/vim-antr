command! -nargs=* Antr      call antr#Antr()
command! -nargs=* AntrBld   call SetBuilder( '<args>' )
command! -nargs=* AntrSet   call SetProject( '<args>' )
command! -nargs=* AntrNew   call CreateProject( '<args>' )
command! -nargs=* AntrCmp   call SetMakeAsAntCompile() | make | copen
command! -nargs=* AntrRun   call SetMakeAsAntRun()  | make | copen
command! -nargs=* AntrTest  call SetMakeAsAntTest() | make | copen
command! -nargs=* AntrClean  call SetMakeAsAntClean() | make | copen

map <F9>  :call SetMakeAsAntCompile()<Return>:make<Return>:copen<Return>

"map <leader>AntRun  :call SetMakeAsAntRun()<CR>:make<CR>:copen<CR>
"map <leader>AntTest :call SetMakeAsAntTest()<CR>:make<CR>:copen<CR>

