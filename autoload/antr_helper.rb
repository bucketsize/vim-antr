module Antr
	def self.log(message)
		`echo "#{Time.now} - #{message}" >> /tmp/antr.log`
	end
end
