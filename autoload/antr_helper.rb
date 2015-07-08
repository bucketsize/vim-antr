module Antr

	#begin
		#VIM::command()
	#rescue NameError => e
			#module VIM
				#def method_missing(*args)
					#Antr.log("method_missing: #{args}")
				#end
			#end
			#include VIM
	#end

	class << self
		def log(message)
			`echo "#{Time.now} - #{message}" >> /tmp/antr.log`
		end
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
				Antr.log("setupMake #{builder} #{cmd} #{className}")

				Antr.log("let &l:makeprg='#{builder.cmd(className)[cmd.to_sym]}'")
				VIM::command("let &l:makeprg='#{builder.cmd(className)[cmd.to_sym]}'")
				
				Antr.log("let &l:errorformat='#{builder.efm()[cmd.to_sym]}'")
				VIM::command("let &l:errorformat='#{builder.efm()[cmd.to_sym]}'")
			else
				VIM::message("command '#{cmd}' not supported")
			end
		end
	end
end
