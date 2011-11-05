# -*- coding: utf-8 -*-

  def skip_scm; false; end
set :application, "chebytoday.ru"
set :domain, "wwwdata@chebytoday.ru"
set :deploy_to, "/home/wwwdata/chebytoday.ru"
# set :repository, 'ssh://danil@dapi.orionet.ru/home/danil/code/chebytoday/.git/'
set :repository, 'git://github.com/dapi/chebytoday.ru.git'

set :rails_env, "production"
# set :revision,  current_revision # 'master/HEAD'
set :keep_releases,	3

set :web_command, "sudo apache2ctl"

set :copy_files, [ 'config/database.yml', 'config/app_config.yml' ]
set :symlinks, [ 'config/database.yml', 'config/app_config.yml' ]

set :rake_cmd, 'bundle exec rake'

set :shared_paths, {
  'log'    => 'log',
  'system' => 'public/system',
  'pids'   => 'tmp/pids',
  'bundle' => 'vendor/bundle',
  '.bundle' => '.bundle'
  # 'sphinx' => 'db/sphinx'
}

set :deploy_tasks, %w[
      vlad:update
      vlad:symlink
      vlad:bundle:install
      vlad:migrate
      vlad:start_app
      vlad:foreverb
      vlad:cleanup
    ]


# rake vlad:loop_dance:restart


# Unicorn

set :unicorn_env, rails_env
set :unicorn_command, "cd #{current_path}; bundle exec unicorn"

namespace :vlad do
  desc 'Restart foreverb'
  remote_task :foreverb do
    puts "Foreverb.."
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec ./script/foreverb-cron.rb"
  end
end

