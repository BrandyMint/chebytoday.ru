
begin
  require 'vlad'
  Vlad.load(:web => 'nginx', :app=>'passenger', :scm => "git") # :app => "passenger2", 
rescue LoadError => e
  puts "Unable to load Vlad #{e}."
end
