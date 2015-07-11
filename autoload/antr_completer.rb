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
		extend Logging

		class << self

			@@cp = []
			@@cp << File.join(Antr::Tasks.getPluginPath(), 'java/target/classes')
			@@cp << File.join(Antr::Tasks.getPluginPath(), 'java/lib/bcel-5.2.jar')

			@@parsed = []
			@@ctagsList = []
			@@ctagsMethodsList = []

			def col(line, col)

				start =	['\s', '=', ';', '\(', '\)', '\{', '\}']
					.map do |sep|
						line.rindex(/#{sep}/).nil? ? 0 : line.rindex(/#{sep}/)+1
					end
					.sort
					.last

				@tag = line[start, line.length]

				@tags = line.split(/\s|=|;|\)|\(|\{|\}/).select do |t|
					!t.empty?
				end
				
				#@tag  = @tags.last
				#start = line.length - @tag.length

				LOG.info("findStart: #{line}, #{col}: #{start}")
				LOG.info("tags: #{@tags}")
				Antr.return(start)
			end

			def ctags(line, col)
				LOG.info("ctags: #{@tag}")

				# if tag is pre-constructor
				if (@tag.strip == 'new') 
					@tag = @tags[-3]
					ctagsOfClasses(@tag)
				elsif (@tag.strip == @tags[-4])
					@tag = @tags[-4]
					ctagsOfMethods(@tag)
				elsif (/^#{@tag.strip}/ =~ @tags[-4])
					@tag = @tags[-4]
					ctagsOfClasses(@tag)
				else
					ctagsOfClasses(@tag)
				end
			end


		def ctagsOfClasses(tag)
			LOG.info("ctagsOfClasses: #{tag}")
			tags = ctagsSearch(@@ctagsList, tag) 
			.join(',')

			LOG.info("ctags: #{tags}")
			Antr.return(tags)
		end

		def ctagsOfMethods(tag)
			LOG.info("ctagsOfMethod: #{tag}")
			classes = ctagsSearch(@@ctagsList, tag) 
			.join(',')

			updateCtagsMethods(classes)

			LOG.info("ctags ctors: #{tags}")
			Antr.return(tags)
		end

		def ctagsSearch(list, tag)
			LOG.info("ctagsSearch ...")
			list.select do |t|
				/^#{tag}/ =~ t
			end
		end

		def updateCtags(jarfile)
			LOG.info("updateCtags ...")
			if not @@parsed.include? jarfile
				LOG.info("parsing jar: #{jarfile}")
				@@parsed << jarfile

				cmd="java -cp #{@@cp.join(':')} com.project.AntrHelper classes #{jarfile}"
				LOG.info("java: #{cmd}")

				_r=`#{cmd}`

				_list = _r.split(',').map{|e| e.strip}
				@@ctagsList += _list 
			end
		end

		def updateCtagsMethods(classes)
			LOG.info("updateCtagsMethods ...")
			m={}
			classes.each do |x|
				l=x.split(x,'-')
				m[l[2]] = [] if m[l[2]].nil? 
				m[l[2]] << l[1]+'.'+l[0]
			end

			m.each_entry do |k, v|
				cmd="java -cp #{@@cp.join(':')} com.project.AntrHelper methods #{k} #{v.join(',')}"
				LOG.info("java: #{cmd}")

				_r=`#{cmd}`
				_list = _r.split(',').map{|e| e.strip}
				@@ctagsMethodsList += _list
			end
		end

		def parseLibDirs()
			LOG.info("parseLibDirs ...")
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

			LOG.info("parseLibDirs => #{jars}")
			jars.each do |jar|
				if not @@parsed.include? jar
					Antr::Completer.updateCtags(jar)
				end
			end
		end

		end
	end
end
