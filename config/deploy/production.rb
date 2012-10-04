#Конфиг деплоя на production
server 'brandymint.ru', :app, :web, :db, :primary => true
set :branch, "master" unless exists?(:branch)
set :rails_env, "production"

require 'airbrake/capistrano'
require "recipes0/init_d/foreverb"

