class Vlad::Nginx

  VERSION = "0.1"

  set :nginx_command,  'sudo /usr/local/etc/rc.d/nginx'

  namespace :vlad do
    desc "(Re)Start the nginx web servers"
    
    remote_task :start_web, :roles => :web  do
      run "#{nginx_command} restart"
    end
    
    desc "Stop the nginx servers"
    remote_task :stop_web, :roles => :web  do
      run "#{nginx_command} stop"
    end

  end

end
