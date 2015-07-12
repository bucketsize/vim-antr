require 'fileutils'

require_relative 'antr_helper'
require_relative 'antr_logger'
require_relative 'antr_builder_factory'
require_relative 'antr_completer'

module Antr

	# provide lifecycle Tasks
	# - set builder [default: ant]
	# - create new project/config
	# - create config for existing sources
	# - builder
	# - run Class
	# - run Test Class
	# - clean TODO
	class Tasks
		include Logging
		extend Logging

		# set project builder, paths
		@@builder = Antr::BuilderFactory.get('ant') 
		LOG.info("set builder  = #{@@builder}")

		@@path_plugin   = VIM::evaluate('g:antr_plugin_path')
		LOG.info("set path_plugin  = #{@@path_plugin}")

		@@path_project  = VIM::evaluate('g:antr_project_path')
		LOG.info("set path_project = #{@@path_project}")


		class << self

			def getBuilder()
				@@builder
			end

			def getPluginPath()
				@@path_plugin
			end

			def getProjectPath()
				@@path_project
			end

			# setup Ant for any source tree / project root
			# default build.xml, build.properties are copied
			# from project template
			def setProject(name)

				cfg = "/../template/#{@@builder.files()[:template]}/#{@@builder.files()[:config]}"
				lib = "/../template/#{@@builder.files()[:template]}/#{@@builder.files()[:lib_dir]}"

				LOG.info("copying resources #{cfg}, #{lib}")

				# check if dir is not under Ant
				if File.exist?(@@builder.files()[:config])
					VIM::message("dir already has config '#{@@builder.files()[:config]}', skipping...")
					return
				end

				# build.xml 
				FileUtils.cp(
					[ 
						@@path_plugin + cfg
					],
					@@path_project)

				# lib/ - test / other libs
				FileUtils.cp_r(
					@@path_plugin + lib,
					@@path_project)

				VIM::message('Antr: created config')
			end

			# create a simple java source tree / project root
			# from project template and managed by Ant
			def createProject(name)

				template = "/../template/#{@@builder.files()[:template]}"

				LOG.info("copying resources #{template} => #{@@path_project}")

				# check if dir is not under Ant
				if File.exist?(@@builder.files()[:config])
					VIM::message("dir already has config '#{@@builder.files()[:config]}', skipping...")
					return
				end

				# ckeck if dir is empty
				if File.exist?('src/')
					VIM::message('dir already has sources try AntrSet to create config, skipping...')
					return
				end

				#copy template
				FileUtils.cp_r(
					@@path_plugin + "#{template}/.",
					@@path_project)

				VIM::message('Antr: created project')
			end

			# set up Ant to compile current managed project
			def makeCompile()
				Antr::Make.setupMake(@@builder, 'make')
			end

			# set up Ant to run a class in a current managed project
			def makeRun(name)
				className = Antr.className(name)
				Antr::Make.setupMake(@@builder, 'run', className)
			end

			# set up Ant to run a junit class in a current managed project
			def self.makeTest(name)
				className = Antr.className(name)
				Antr::Make.setupMake(@@builder, 'test', className)
			end

			# set a project builder from Antr::Builder::BUILDERS
			def setBuilder(name='ant')
				if (Antr::BuilderFactory::BUILDERS.include?(name))
					@@builder = Antr::BuilderFactory.get(name)
				else
					VIM::message("builder unknown - '#{name}'")
					@@builder = Antr::BuilderFactory.get('ant')
				end
				VIM::message("builder set as '#{@@builder}'")
			end

			# clean target
			def makeClean()
				Antr::Make.setupMake(@@builder, 'clean')
			end

		end
	end
end
