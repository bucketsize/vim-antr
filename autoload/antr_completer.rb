require_relative 'antr_helper'
require_relative 'antr_logger'
require_relative 'antr_tasks'

# Deprecated use javacomplete2
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

		L_DELIM = ','
		F_DELIM = '|'

		class << self

			@@cp = []
			@@cp << File.join(Antr::Tasks.getPluginPath(), 'java/target/classes')
			@@cp << File.join(Antr::Tasks.getPluginPath(), 'java/lib/bcel-5.2.jar')

			@@parsed = []
			@@ctagsList = []
			@@ctagsMethodsList = []

			def col(line, col)
				#start of insert
				# - lastDelimPos+1
				start =	['\s', '=', ';', '\(', '\)', '\{', '\}']
				.map do |sep|
					line.rindex(/#{sep}/).nil? ? 0 : line.rindex(/#{sep}/)+1
				end
				.sort
				.last


				@tag = line[start, line.length].strip

				# if tag=modifiers like [new]
				# - lastDelimPos + len(new)+1(space)
				if ['new'].include? @tag
					start += (@tag.length + 2)
				end

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

				# ctor
				# - pre-ctor 	[ .. a=new|]
				if (@tag == 'new') 
					@tag = @tags[-3]
					ctagsOfClasses(@tag)
					# - pre-ctor	[ .. a=new |]
				elsif (@tag.empty? and @tags[-1] == 'new')
					@tag = @tags[-3]
					ctagsOfMethods(@tag)
					# - partial-ctor [ .. a=new An|]
				elsif (/^#{@tag}/ =~ @tags[-3])
					@tag = @tags[-4]
					ctagsOfClasses(@tag)
					# - Type var decl [ ..  An|]
				else
					ctagsOfClasses(@tag)
				end
			end


			def ctagsOfClasses(tag)
				LOG.info("ctagsOfClasses: #{tag}")
				tags = ctagsSearch(@@ctagsList, tag) 

				LOG.info("ctags: #{tags}")
				Antr.return(tags.join(L_DELIM))
			end

			def ctagsOfMethods(tag)
				LOG.info("ctagsOfMethod: #{tag}")
				classes = ctagsSearch(@@ctagsList, tag) 

				tags = updateCtagsMethods(classes)

				LOG.info("ctags ctors: #{tags}")
				Antr.return(tags.join(L_DELIM))
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
					LOG.info("java> #{_r}")

					_list = _r.split(L_DELIM).map{|e| e.strip}
					@@ctagsList += _list 
				end
				@@ctagsList
			end

			def updateCtagsMethods(classes)
				LOG.info("updateCtagsMethods: #{classes}")
				m={}
				classes.each do |x|
					l=x.split(F_DELIM)
					LOG.info("lookup methods: #{l}")
					m[l[2]] = [] if m[l[2]].nil? 
					m[l[2]] << l[1]+'.'+l[0]
				end

				m.each_entry do |k, v|
					cmd="java -cp #{@@cp.join(':')} com.project.AntrHelper methods #{k} #{v.join(',')}"
					LOG.info("java: #{cmd}")

					_r=`#{cmd}`
					LOG.info("java> #{_r}")

					_list = _r.split(L_DELIM).map{|e| e.strip}
					LOG.info("cache: #{_list}")
					@@ctagsMethodsList += _list
				end
				@@ctagsMethodsList
			end

			def parseLibDirs()
				LOG.info("parseLibDirs ...")
				builder = Antr::Tasks.getBuilder()
				projectPath = Antr::Tasks.getProjectPath()
        LOG.info("path=#{projectPath}")

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
