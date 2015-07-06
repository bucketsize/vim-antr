module Antr
	class << self
		def log(message)
			`echo "#{Time.now} - #{message}" >> /tmp/antr.log`
		end
		def return(val)		
			VIM::command("let g:rval=\"#{val}\"")
		end
	end
end
