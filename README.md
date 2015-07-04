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

