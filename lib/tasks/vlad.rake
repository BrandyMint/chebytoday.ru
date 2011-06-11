if defined? Vlad
  Vlad.load(:app=>'passenger', :scm => "git")
  require 'vlad/loop_dance'
end
