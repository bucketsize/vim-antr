require 'fileutils'

require_relative 'antr_helper'
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

		# project builder
		@@builder = Antr::BuilderFactory.get('ant') 
		def self.getBuilder()
			@@builder
		end

		# setup important paths from startup load
		@@path_plugin   = VIM::evaluate('g:antr_plugin_path')
		def self.getPluginPath()
			@@path_plugin
		end
		Antr.log("set path_plugin  = #{@@path_plugin}")

		@@path_project  = VIM::evaluate('g:antr_project_path')
		def self.getProjectPath()
			@@path_project
		end
		Antr.log("set path_project = #{@@path_project}")

    # setup Ant for any source tree / project root
    # default build.xml, build.properties are copied
    # from project template
    def self.setProject(name)
    
			cfg = "/../template/#{@@builder.files()[:template]}/#{@@builder.files()[:config]}"
			lib = "/../template/#{@@builder.files()[:template]}/#{@@builder.files()[:lib_dir]}"

			Antr.log("copying resources #{cfg}, #{lib}")

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
    def self.createProject(name)
      
			template = "/../template/#{@@builder.files()[:template]}"
			
			Antr.log("copying resources #{template} => #{@@path_project}")
      
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
    def self.makeCompile()
      Antr.setupMake(@@builder, 'make')
    end

    # set up Ant to run a class in a current managed project
    def self.makeRun(name)
      className = Antr.className(name)
      Antr.setupMake(@@builder, 'run', className)
    end
    
    # set up Ant to run a junit class in a current managed project
    def self.makeTest(name)
      className = Antr.className(name)
      Antr.setupMake(@@builder, 'test', className)
		end

		# set a project builder from Antr::Builder::BUILDERS
		def self.setBuilder(name='ant')
			if (Antr::BuilderFactory::BUILDERS.include?(name))
				@@builder = Antr::BuilderFactory.get(name)
			else
				VIM::message("builder unknown - '#{name}'")
				@@builder = Antr::BuilderFactory.get('ant')
			end
			VIM::message("builder set as '#{@@builder}'")
		end

		def self.makeClean()
			Antr.setupMake(@@builder, 'clean')
		end

  end
end
