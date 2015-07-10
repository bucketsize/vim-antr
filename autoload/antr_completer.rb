require_relative 'antr_helper'
require_relative 'antr_tasks'

module Antr
	# handle Completion in the following cases:
	#
	# - complete partial Type 
	# | tags [0-p], [;-p]
	#
	# - complete constructors 
	# | tags [after new+space] 
	#
	# - suggest constructor overrides 
	# | tags [new+space+col]
	#
	# - suggest methods on instance variables 
	# | tags [ctor+.] [ctor+.+p] [vars after Type+space]
	class Completer
		class << self

					@cp = []
					@cp << File.join(pluginPath, 'java/target/classes')
					@cp << File.join(pluginPath, 'java/lib/bcel-5.2.jar')

			@@ctagsList = []
			@@ctagsCtorsList = []
			@@parsed = []

			def col(line, col)

				#start = 
					#[' ','\t', ';']
					#.map do |sep|
						#line.rindex(sep).nil? ? 0 : line.rindex(sep)+1
					#end
					#.sort
					#.last

				#@tag = line[start, line.length]
				@tags = line.split(/\ |\t|;/)
				@tag  = @tags.last

				start = line.length - @tag.length
				
				Antr.log("findStart: #{line}, #{col}: #{start}")
				Antr.log("tags: #{@tags}")
				Antr.return(start)
			end

			def ctags(line, col)
				Antr.log("ctags: #{@tag}")
			
				# if tag is pre-constructor
				if (@tag.strip == 'new') 
					@tag = @tags[-3]
					ctagsOfClasses(@tags)
				elsif (@tag.strip != @tags[-4])
					@tag = @tags[-4]
					ctagsOfClasses(@tags)
				elsif (@tag.strip == @tags[-4])
					@tag = @tags[-4]
					ctagsOfCtor(@tags)
				end

			end

			def ctagsOfClasses(tag)
				tags = ctagsSearch(@ctagsList, tag) 
						.join(',')
				
				Antr.log("ctags: #{tags}")
				Antr.return(tags)
			end

			def ctagsOfCtors(tag)
				classes = ctagsSearch(@ctagsList, tag) 
						.join(',')
	
				updateCtagsCtors(classes)
				
				Antr.log("ctags ctors: #{tags}")
				Antr.return(tags)
			end

			def ctagsOfMethods(tag)
			end

			def ctagsSearch(list, tag)
				list.select do |t|
					/^#{tag}/ =~ t
				end
			end

			def updateCtags(jarfile)
				Antr.log("updateCtags ...")
				pluginPath = Antr::Tasks.getPluginPath()
				if not @@parsed.include? jarfile
					Antr.log("parsing jar: #{jarfile}")
					@@parsed << jarfile

					cmd="java -cp #{@cp.join(':')} com.project.AntrHelper class #{jarfile}"
					Antr.log("java: #{cmd}")

					_r=`#{cmd}`
						
					_list = _r.split(',').map{|e| e.strip}
					@@ctagsList += _list 
				end
			end
			
			def updateCtagsCtors(classes)
				classes.each do |x|
					l=x.split(x,'-')

					cmd="java -cp #{@cp.join(':')} com.project.AntrHelper ctor #{l[2]} #{l[1]}.#{l[0]}"
					Antr.log("java: #{cmd}")

					_r=`#{cmd}`
					_list = _r.split(',').map{|e| e.strip}
					@@ctagsCtorsList += _list
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
