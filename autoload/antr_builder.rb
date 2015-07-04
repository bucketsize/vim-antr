module Antr

	# the builder interface
	module Builder
		def cmd(a,b,c=Nil)
			throw "overide!"
		end
		def efm
			throw "overide!"
		end
		def files
			throw "overide!"
		end
	end

end
