# -*- coding: utf-8 -*-
source 'http://rubygems.org'

gem 'rails', '~> 3.0.3'
gem 'pg'
gem 'state_machine'
gem 'acts-as-taggable-on'
gem "haml"
gem "compass"

gem "formtastic", "~> 1.1.0" #, :git => "http://github.com/justinfrench/formtastic.git", :branch => "rails3"
gem "truncate_html", :git =>'git://github.com/dapi/truncate_html.git'
gem "feedzirra"

if `hostname`=~/dapi/
  gem 'loop_dance', :path => '/home/danil/code/gems/loop_dance'
  #   gem 'stateful_link', :path => '/home/danil/code/gems/stateful_link/'
else
  gem 'loop_dance', '~> 0.4.1'
  #   #gem 'stateful_link', :git => 'git://github.com/gzigzigzeo/stateful_link.git'
end

gem 'stateful_link', :git => 'git://github.com/dapi/stateful_link.git'

gem "exception_notification"
gem 'mail'

gem "devise", :git => "git://github.com/plataformatec/devise.git"

gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
#gem 'rails_admin', :path => '/home/danil/code/gems/rails_admin'

gem "will_paginate", "~> 3.0.pre2"
gem 'twitter'
gem 'grackle'

#gem "russian"
gem "russian", :git => "https://github.com/dima4p/russian.git"


gem "hpricot"

gem "haml-rails"                # вместо подкрутки application.rb
gem "jquery-rails"

group :development, :test do
  gem 'bson_ext'                # Не помню для чего это
  gem 'ruby-debug'
  gem 'rack-bug'
  gem 'vlad'
  gem 'hpricot'
  gem 'vlad-git'
  gem 'rcov'
  gem "rails3-generators"
  gem "nifty-generators"
  gem "metric_fu"
  gem 'awesome_print', :require => 'ap'
  gem 'wirble', :require => 'wirble'
  gem "mocha", :group => :test
  #gem 'limerick_rake', :git => "http://github.com/dapi/limerick_rake.git", :branch => "rails3"
  gem "mocha", :group => :test
  #gem 'looksee', :require => 'looksee'
end
