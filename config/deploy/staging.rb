#Конфиг деплоя на staging
server 'brandymint.ru', :app, :web, :db, :primary => true
set :application, "stage.chebytoday.ru"
set(:current_branch) { `git branch`.match(/\* (\S+)\s/m)[1] || raise("Couldn't determine current branch") }
set :branch, defer { current_branch } unless exists?(:branch)
set :rails_env, "development"

