require 'logger'

module Antr
	module Logging
		LOG = Logger.new('/tmp/antr.log')
		LOG.formatter = proc { |severity, datetime, progname, msg|
    	"#{severity} #{caller[4]} #{msg}\n"
  	}	
	end
end
