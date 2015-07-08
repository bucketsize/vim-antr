require_relative 'antr_helper'
require_relative 'antr_tasks'

module Antr
	class Completer
		class << self

			@@ctagsList = []
			@@parsed = []

			def findStart(line, col)
				Antr.log("#{line}, #{col}")
				Antr.return(col)
			end

			def ctags(tag)
				# search and return set
				@@ctagsList.join(',')
			end

			def updateCtags(jarfile)
				Antr.log("updateCtags ...")
				pluginPath = Antr::Tasks.getPluginPath()
				if not @@parsed.include? jarfile
					Antr.log("parsing jar: #{jarfile}")
					@@parsed << jarfile
					cp = []
					cp << File.join(pluginPath, 'java/classes')
					cp << File.join(pluginPath, 'java/lib/bcel-5.2.jar')

					cmd="java -cp #{cp.join(':')} com.project.AntrHelper #{jarfile}"
					Antr.log("java: #{cmd}")

					r=`#{cmd}`
					@@ctagsList = @@ctagsList + r.split(',')	
				end
			end

			def parseLibDirs()
				Antr.log("parseLibDirs ...")
				builder = Antr::Tasks.getBuilder()
				projectPath = Antr::Tasks.getProjectPath()

				jars = []
				builder.libDirs.each do |folder|
					jars = jars + 
					Dir
					.entries(File.join(projectPath, folder))
					.select {|f| (!File.directory?(f) && File.extname(f) == '.jar') }
					.map {|f| File.join(projectPath, folder, f)}
				end

				Antr.log("parseLibDirs => #{jars}")
				jars.each do |jar|
					Antr::Completer.updateCtags(jar)
				end
			end

		end
	end
end
