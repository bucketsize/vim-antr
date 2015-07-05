module Antr

	# the builder interface
	module Builder
		def cmd(a,b,c=Nil)
			raise "overide!"
		end
		def efm
			raise "overide!"
		end
		def files
			raise "overide!"
		end
		def libDirs
			raise "overide!"
		end
	end

end
