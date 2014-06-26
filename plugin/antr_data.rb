module Antr

  # data for make overide
  CMD={
    :make  => 'ant -find build.xml compile',
    :run   => 'ant -find build.xml run-main -Dname=CLASS_NAME',
    :test  => 'ant run-test -Dname=CLASS_NAME'
  }

  # data for errorformat overide 
  EFM={
    :make => '%-G%.%#build.xml:%.%#,' \
    + '%A\ %#[javac]\ %f:%l:\ %m,' \
    + '%C\ %#[javac]\ %m,' \
    + '%-Z\ %#[javac]\ %p^,' \
    + '%-C%.%#',

    :run  => '\EException\ %m',

    :test => '\EException\ %m'
  }

end
