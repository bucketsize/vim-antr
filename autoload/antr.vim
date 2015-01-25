" if exists('g:antr_loaded') || &cp 
"   finish
" endif

echom "Antr loaded"

" init
let g:antr_loaded=1
  
let g:antr_plugin_path=expand('<sfile>:p:h')

" public functions
func! antr#Antr()
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

