# -*- coding: utf-8 -*-

set :application, "chebytoday.ru"
set :domain, "wwwdata@chebytoday.ru"
set :deploy_to, "/home/wwwdata/chebytoday.ru"
# set :repository, 'ssh://danil@dapi.orionet.ru/home/danil/code/chebytoday/.git/'
set :repository, 'git://github.com/dapi/chebytoday.ru.git'

set :rails_env, "production"
# set :revision,  current_revision # 'master/HEAD'
set :keep_releases,	3

set :web_command, "sudo apache2ctl"

set :copy, [ 'config/database.yml', 'config/app_config.yml' ]
set :symlinks, copy

set :shared_paths, {
  'log'    => 'log',
  'system' => 'public/system',
  'pids'   => 'tmp/pids',
  'bundle' => 'vendor/bundle',
  '.bundle' => '.bundle'
  # 'sphinx' => 'db/sphinx'
}


# for rails
# set :shared_paths, {
#   'log'    => 'log',
#   'system' => 'public/system',
#   'pids'   => 'tmp/pids',
#   'bundle' => 'vendor/bundle'
# }

# namespace :vlad do

#   desc "Full deployment cycle"
#   task "deploy" => %w[
#       vlad:update
#       vlad:migrate
#       vlad:start_web
#       vlad:restart_dancers
#       vlad:cleanup
#     ]


#   #

#   desc "Restart dancers"
#   remote_task :restart_dancers do
#     puts "Restart dancers #{current_release}"
#     run "cd #{current_release}; RAILS_ENV=production rake loop_dance:dancer:restart"
#   end

#   # # Add an after_update hook
#   # #
#   remote_task :update do
#     Rake::Task['vlad:share_configs'].invoke
#     Rake::Task['vlad:bundle'].invoke
#   end

#   #
#   # Fixes vlad/passenger bad latest_release path
#   #
#   remote_task :start_app => :fix_release
#   remote_task :fix_release do
#     puts "fix passenger release path"
#     #set :latest_release, current_release
#     set :deploy_timestamped, false # Такой метод больше понравился :)
#   end

#   remote_task :update_gems do
#     run "sudo gem update --system"
#     #run "cd #{current_release}; bundle install --deployment"
#   end

#   # remote_task :after_setup do
#   #   # Link to shared resources, if you have them in .gitignore
#   #   run "mkdir #{deploy_to}/logs"
#   # end

#   #  #
#   #  # The after_update hook, which is run after vlad:update
#   #  #
#   desc "Share config files (database.yml and app_config.yml)"
#   remote_task :share_configs do
#     puts "Share config files"
#     run "cd #{current_release}/config/; scp #{local_link}/config/database.yml . ; scp #{local_link}/config/app_config.yml ."
#   end

#   desc "Exec bundle --deployment"
#   remote_task :bundle do
#     puts "Exec bundle"
#     #run "cd #{current_release}; sudo bundle install --deployment" # На FreeBSD только через sudo
#     run "cd #{current_release}; sudo bundle --without development --without test" # На FreeBSD только через sudo
#     # chown current_release after bundle
#   end

# end
