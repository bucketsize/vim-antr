require_relative 'antr_ant_builder'

module Antr

	# module to create builders
	module BuilderFactory
		BUILDERS = ['mvn', 'ant']
		def self.get(name)
			case
			when name == 'ant'
				Antr::AntBuilder.new
			else
				throw 'not implemented'
			end
		end
	end

end
