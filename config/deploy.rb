# -*- coding: utf-8 -*-

set :application, "chebytoday.ru"
set :domain, "wwwdata@chebytoday.ru"
set :deploy_to, "/home/wwwdata/chebytoday.ru"
set :repository, 'ssh://danil@dapi.orionet.ru/home/danil/code/chebytoday/.git/'
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

