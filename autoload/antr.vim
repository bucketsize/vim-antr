" if exists('g:antr_loaded') || &cp 
"   finish
" endif

echom "Antr loaded"

" init
let g:antr_loaded=1
let g:antr_plugin_path=expand('<sfile>:p:h')

" public functions

" entry point to init
func! antr#Antr()
	"let g:antr_project_path=expand('%:p:h')
	let g:antr_project_path=getcwd()

	" load ruby script (require)
	exec "rubyf ".g:antr_plugin_path."/antr_tasks.rb"

	" ----------------------------------------------------
  " deprecating - in favour of javacomplete2
  " exec "rubyf ".g:antr_plugin_path."/antr_completer.rb"
	" load libs
  " call ParseLibDirs()
  " ----------------------------------------------------
endfunc

" func mapping; always delegating to ruby methods
" avoid doing anything in vim-script
func! SetBuilder(pname)
	ruby Antr::Tasks.setBuilder(VIM::evaluate('a:pname'))
endfunc

func! SetProject(pname)
	ruby Antr::Tasks.setProject(VIM::evaluate('a:pname'))
endfunc

funct! CreateProject(pname)
	ruby Antr::Tasks.createProject(VIM::evaluate('a:pname'))
endfunc

"? deprecated
"funct! RunMain(c_name)
	"ruby Antr::Tasks.makeRun(VIM::evaluate('a:c_name'))
"endfunc

func! SetMakeAsAntCompile()
	ruby Antr::Tasks.makeCompile()
endfunc

func! SetMakeAsAntRun()
	ruby Antr::Tasks.makeRun(VIM::evaluate('expand("%")'))
endfunc

func! SetMakeAsAntCompileRun()
	ruby Antr::Tasks.makeCompileRun(VIM::evaluate('expand("%")'))
endfunc

func! SetMakeAsAntTest()
	ruby Antr::Tasks.makeTest(VIM::evaluate('expand("%")'))
endfunc

func! SetMakeAsAntClean()
	ruby Antr::Tasks.makeClean()
endfunc

" -----------------------------------------------------------
" deprecating as the exists better alternatives for java aut-
" ocomplete, ala. javacomplete2
func! ParseLibDirs()
	ruby Antr::Completer.parseLibDirs()
endfunc

func! antr#ListSymbols(findstart, base)
	if a:findstart
		ruby Antr::Completer.col(VIM::evaluate("getline('.')"),	VIM::evaluate("col('.')"))
		return g:rval
	endif

	ruby Antr::Completer.ctags(VIM::evaluate("getline('.')"),	VIM::evaluate("col('.')"))

	let a:list = split(g:rval, ",")
	call map(a:list, 'Rf(v:val)')
	
	return a:list
endfunc

func! Rf(x)
	let a:list = split(a:x, "|")
	if len(a:list) == 0 
		return ""
	endif
	return {'word': a:list[0], 'menu': a:list[1], 'kind': 'f'}
endfunc
" -----------------------------------------------------------
