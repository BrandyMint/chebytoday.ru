if defined? Vlad
  Vlad.load(:app=>'unicorn_rails', :scm => "git")
  require 'vlad/loop_dance'
end
