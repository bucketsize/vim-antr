require_relative "antr_builder"

module Antr

	# builder using apache ant
	class AntBuilder
		include Builder

		# data for make overide
		def cmd(className='_NONE_') 
			{
				:make  => "ant -find build.xml compile",
				:run   => "ant -find build.xml run-main -Dname=#{className}",
				:test  => "ant run-test -Dname=#{className}",
				:clean  => "ant clean"
			}
		end

		# data for errorformat overide 
		def efm
			#make = <<-EOS
					 #%-G%.%#build.xml:%.%#, 
					 #%A\ %#[javac]\ %f:%l:\ %m, 
					 #%C\ %#[javac]\ %m, 
					 #%-Z\ %#[javac]\ %p^, 
					 #%-C%.%#
			#EOS

			make = [
				'%-G%.%#build.xml:%.%#,', 
				'%A\ %#[javac]\ %f:%l:\ %m,',
				'%C\ %#[javac]\ %m,',
				'%-Z\ %#[javac]\ %p^,',
				'%-C%.%#'
			]

			{
				:make => make.join,
				:run  => '\EException\ %m',
				:test => '\EException\ %m'
			}
		end

		# data for managing project
		def files
			{
				:config => 'build.xml',
				:lib_dir => 'lib',
				:src_dir => 'src',
				:build_dir => 'target',
				:template => 'ant'
			}
		end

		def libDirs
			['lib/']
		end

	end
end
