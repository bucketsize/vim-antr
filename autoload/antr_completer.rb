require_relative 'antr_helper'
require_relative 'antr_tasks'

module Antr
	class Completer
		class << self

			@@ctagsList = []
			@@parsed = []

			def findStart(line, col)
				Antr.log("findStart: #{line}, #{col}")
				start=if line.index(' ').nil?
					0
				else
					line.index(' ')+1
				end

				@tag = line[start, line.length]
				
				Antr.return(start)
			end

			def ctags(line, col)
				Antr.log("ctags: #{@tag}")
				
				# search and return set
				tags = 
					@@ctagsList
						.select do |t|
							/^#{@tag}/ =~ t
						end
						.join(',')
				
				Antr.log("returning: #{tags}")
				Antr.return(tags)
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

					_r=`#{cmd}`
					_ra = _r.split(':')
						
					#_list =	_ra[1].split(',').map do |e| 
						#_e = e.split('-')
						#"{'word':#{_e[0]}, 'menu':#{_e[1]}}" 
					#end
			
					_list = _ra[1].split(',').map{|e| e.strip}
					@@ctagsList = @@ctagsList + _list 
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
