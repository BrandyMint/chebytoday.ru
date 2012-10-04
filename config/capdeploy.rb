#Конфик мультистейджа. Должен быть в начале.
#Стейдж нельзя называть 'stage', поэтому зовем его 'staging'
set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

#Приложение
set :application, "chebytoday.ru"

#Репозиторий
set :scm, :git
set :repository,  "git@github.com:BrandyMint/#{application}.git"
set :deploy_via, :remote_cache
#set :git_enable_submodules, 1
set :scm_verbose, true
#Используем локальные ключи для приватных репозиториев на github
#В ~/.ssh/config на локальной машине должен быть прописан ForwardAgent yes
#https://help.github.com/articles/using-ssh-agent-forwarding
ssh_options[:forward_agent] = true

#Учетные данные на сервере
set :user,      'wwwchebytoday'
set :deploy_to,  defer { "/home/#{user}/#{application}" }
set :use_sudo,   false

#Все остальное
set :keep_releases, 3
set :shared_children, fetch(:shared_children) + %w(public/uploads)

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"") # Read from local system
set :rvm_type, :user

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
before 'deploy:restart', 'deploy:migrate'
after 'deploy:restart', "deploy:cleanup"
after 'deploy:finalize_update', 'chebytoday:symlink_configs'

#RVM, Bundler
require "rvm/capistrano"
require "bundler/capistrano"
require "recipes0/database_yml"
#require "recipes0/assets"
require "recipes0/nginx"
require "recipes0/init_d/unicorn"
#require "recipes0/init_d/delayed_job"
require "recipes0/db/pg"

#Newrelic
#require 'new_relic/recipes'
#after "deploy:update", "newrelic:notice_deployment"

#Airbrake
#require 'airbrake/capistrano'

namespace :chebytoday do
   task :symlink_configs, :except => { :no_release => true } do
      run "ln -nfs #{shared_path}/config/app_config.yml #{release_path}/config/app_config.yml" 
   end
end

