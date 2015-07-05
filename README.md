vim-antr
========

ChangeLog
---------

2015/07/04
- backend builder[ant:default, mvn:TODO] is now configurable
- added logging >> /tmp/antr.logging
- added clean project command

Description
-----------
Creates Java project template / configures existing with ant for build, single class run and junit test run.

Commands
--------
* Antr - initialize plugin
* AntrBld - select a builder backend ex: [ant, mvn] default: ant
* AntrSet - configure for existing standard java source tree
* AntrNew - create a sample base java project
* AntrCmp / F9 - compile the project with ant
* AntrRun / F10 - runs class in current buffer, class first needs to be successfully compiled and must have 'main' entry point
* AntrTest - launch junit test in current buffer
* AntrClean - clean project

Other plugins
-------------
- [javacomplete] (https://github.com/paretje/javacomplete)

Note: 

nailgun is autostart from `java/lib/` 

loads `java...jar` from `java/target/`
```bash 
	cd ~/.vim/bundle/javacomplete/java
	mvn clean install
```

In `java/pom.xml` set `jdk-tools` dependency to systempath, as it fails to find from repo.

```xml
		<dependency>
			<groupId>jdk.tools</groupId>
			<artifactId>jdk-tools</artifactId>
			<scope>system</scope>
			<version>1.8</version>
			<systemPath>${JAVA_HOME}/lib/tools.jar</systemPath>
		</dependency>
```

.vimrc
```viml
let g:nailgun_port='2113'
let g:javacomplete_ng='ng-nailgun'
autocmd Filetype java setlocal omnifunc=javacomplete#Complete
autocmd Filetype java map <leader>b :call javacomplete#GoToDefinition()<CR>

```


