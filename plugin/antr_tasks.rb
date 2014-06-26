require 'fileutils'

require_relative 'antr_utils'
require_relative 'antr_data'

module Antr
  class Tasks

    # setup important paths from startup load 
    @@path_plugin   = VIM::evaluate('g:antr_plugin_path')
    @@path_project  = VIM::evaluate('g:antr_project_path')

    # setup Ant for any source tree / project root
    # default build.xml, build.properties are copied
    # from project template
    def self.set_project(name)
     
      # check if dir is not under Ant
      if File.exist?('build.xml')
        VIM::message('dir already has Ant config, skipping...')
        return
      end

      FileUtils.cp(
        [ 
          @@path_plugin+'/../template/project/build.xml',
          @@path_plugin+'/../template/project/build.properties'
        ],
        @@path_project)
      
      VIM::message('Antr: created config')
    end

    # create a simple java source tree / project root
    # from project template and managed by Ant
    def self.create_project(name)
      
      # check if dir is not under Ant
      if File.exist?('build.xml')
        VIM::message('dir already has Ant config, skipping...')
        return
      end
      
      # ckeck if dir is empty
      if File.exist?('src/')
        VIM::message('dir already has sources try AntrSet to create Ant config, skipping...')
        return
      end

      #copy template
      FileUtils.cp_r(
        @@path_plugin+'/../template/project/.',
        @@path_project)

      VIM::message('Antr: created project')
    end

    # set up Ant to compile current managed project
    def self.make_compile()
      Utils.setup_make(Antr::CMD[:make], Antr::EFM[:make])
    end

    # set up Ant to run a class in a current managed project
    def self.make_run(name)
      class_name = Utils.class_name(name)
      Utils.setup_make(Antr::CMD[:run].gsub('CLASS_NAME', class_name), Antr::EFM[:run])
    end
    
    # set up Ant to run a junit class in a current managed project
    def self.make_test(name)
      class_name = Utils.class_name(name)
      Utils.setup_make(Antr::CMD[:test].gsub('CLASS_NAME', class_name), Antr::EFM[:test])
    end

  end
end
