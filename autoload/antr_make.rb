require_relative 'antr_logger'

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

  extend Logging
	class << self
		def return(val)		
			VIM::command("let g:rval=\"#{val}\"")
		end
		def className(fileName)
      LOG.info("filename: #{fileName}")
      fileName.split(/\/|\./)[1..-2].join('.')
		end
	end

	class Make
		extend Logging
	
		class << self

			def setupMake(builder, cmd, className='_NONE_')
				if builder.cmd.keys.include?(cmd.to_sym)
					LOG.info("setupMake #{builder} #{cmd} #{className}")

					LOG.info("let &l:makeprg='#{builder.cmd(className)[cmd.to_sym]}'")
					VIM::command("let &l:makeprg='#{builder.cmd(className)[cmd.to_sym]}'")

					LOG.info("let &l:errorformat='#{builder.efm()[cmd.to_sym]}'")
					VIM::command("let &l:errorformat='#{builder.efm()[cmd.to_sym]}'")
				else
					VIM::message("command '#{cmd}' not supported by #{builder}")
				end
			end
		end
	end
end
