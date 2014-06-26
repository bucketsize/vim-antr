if exists('g:antr_loaded') || &cp 
  finish
endif

" init
let g:antr_loaded=1
  
let g:antr_plugin_path=expand('<sfile>:p:h')

" public functions
func! Antr()
  let g:antr_project_path=expand('%:p:h')

  " load ruby script (require)
  exec "rubyf ".g:antr_plugin_path."/antr_tasks.rb"
endfunc

func! SetProject(pname)
  ruby Antr::Tasks.set_project(VIM::evaluate('a:pname'))
endfunc

funct! CreateProject(pname)
  ruby Antr::Tasks.create_project(VIM::evaluate('a:pname'))
endfunc

funct! RunMain(c_name)
  ruby Antr::Tasks.make_run(VIM::evaluate('a:c_name'))
endfunc

func! SetMakeAsAntRun()
  ruby Antr::Tasks.make_run(VIM::evaluate('expand("%:t:r")'))
endfunc

func! SetMakeAsAntTest()
  ruby Antr::Tasks.make_test(VIM::evaluate('expand("%:t:r")'))
endfunc

func! SetMakeAsAntCompile()
  ruby Antr::Tasks.make_compile()
endfunc

command! -nargs=* Antr      call Antr()
command! -nargs=* AntrSet   call SetProject( '<args>' )
command! -nargs=* AntrNew   call CreateProject( '<args>' )
command! -nargs=* AntrCmp   call SetMakeAsAntCompile() | make | copen
command! -nargs=* AntrRun   call SetMakeAsAntRun()  | make | copen
command! -nargs=* AntrTest  call SetMakeAsAntTest() | make | copen

map <F9>  :call SetMakeAsAntCompile()<Return>:make<Return>:copen<Return>

"map <leader>AntRun  :call SetMakeAsAntRun()<CR>:make<CR>:copen<CR>
"map <leader>AntTest :call SetMakeAsAntTest()<CR>:make<CR>:copen<CR>
