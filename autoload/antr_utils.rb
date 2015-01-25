module Antr
  class Utils
    def self.class_name(fileName)
      IO.popen("find -name #{fileName}.class") do |f| 
        r = f.gets
        cn = r.split('/classes/')[1].split('.')[0]
        cn
      end
    end
    def self.vim_return(str)
        VIM::command("let rRETURN = '#{str}'")
    end
    def self.setup_make(cmd, efm)
      VIM::command("let &l:makeprg='#{cmd}'")
      VIM::command("let &l:errorformat='#{efm}'")
    end
  end
end
