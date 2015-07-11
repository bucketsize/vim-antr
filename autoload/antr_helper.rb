require 'logger'

module Antr

	#begin
		#VIM::command()
	#rescue NameError => e
			#module VIM
				#def method_missing(*args)
					#LOG.info("method_missing: #{args}")
				#end
			#end
			#include VIM
	#end

	module Logging
		LOG = Logger.new('/tmp/antr.log')
		LOG.formatter = proc { |severity, datetime, progname, msg|
    	"#{severity} #{caller[4]} #{msg}\n"
  	}	
	end

	class << self
		def return(val)		
			VIM::command("let g:rval=\"#{val}\"")
		end
    def className(fileName)
      IO.popen("find -name #{fileName}.class") do |f| 
        r = f.gets
        cn = r.split('/classes/')[1].split('.')[0]
        cn #FQCN
      end
    end
		def setupMake(builder, cmd, className='_NONE_')
			if Antr::BuilderFactory::COMMANDS.include?(cmd)
				LOG.info("setupMake #{builder} #{cmd} #{className}")

				LOG.info("let &l:makeprg='#{builder.cmd(className)[cmd.to_sym]}'")
				VIM::command("let &l:makeprg='#{builder.cmd(className)[cmd.to_sym]}'")
				
				LOG.info("let &l:errorformat='#{builder.efm()[cmd.to_sym]}'")
				VIM::command("let &l:errorformat='#{builder.efm()[cmd.to_sym]}'")
			else
				VIM::message("command '#{cmd}' not supported")
			end
		end
	end
end
