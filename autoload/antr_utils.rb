require_relative 'antr_helper'

module Antr
  class Utils
    def self.className(fileName)
      IO.popen("find -name #{fileName}.class") do |f| 
        r = f.gets
        cn = r.split('/classes/')[1].split('.')[0]
        cn #FQCN
      end
    end
    def self.vimReturn(str)
        VIM::command("let rRETURN = '#{str}'")
    end
		def self.setupMake(builder, cmd, className='_NONE_')
			if Antr::BuilderFactory::COMMANDS.include?(cmd)
				Antr.log("setupMake #{builder} #{cmd} #{className}")

				Antr.log("let &l:makeprg='#{builder.cmd(className)[cmd.to_sym]}'")
				Antr.log("let &l:errorformat='#{builder.efm()[cmd.to_sym]}'")
				
				VIM::command("let &l:makeprg='#{builder.cmd(className)[cmd.to_sym]}'")
				VIM::command("let &l:errorformat='#{builder.efm()[cmd.to_sym]}'")
			else
				VIM::message("command '#{cmd}' not supported")
			end
		end
  end
end
