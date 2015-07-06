require_relative 'antr_helper'

module Antr
	class Completer
		class << self
			def start(line, col)
				Antr.log("#{line}, #{col}")
				Antr.return(col)
			end

			def ctags(ptag)
				Antr.return('a|apple,b|ball,c|catch')			
			end

			def updateCtags(lib_path)
			end

		end
	end
end
