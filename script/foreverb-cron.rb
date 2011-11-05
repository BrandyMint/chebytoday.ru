#!/usr/bin/env ruby
puts 'Load rails environment..'
require File.expand_path('../../config/environment', __FILE__)

#puts 'Load rake tasks..'
#require 'rake'
#BlogsInvestcafeRu::Application.load_tasks

require 'forever'

Forever.run do
  ##
  # You can set these values:
  #
  # dir  "foo"     # Default: File.expand_path('../../', __FILE__)
  # Default: __FILE__
  #
  filename=File.expand_path('../../', __FILE__)
  puts "File: #{file}"

  if file=~/wwwdata/
    deploy_dir = '/home/wwwdata/chebytoday.ru'
    puts "Foreverb deploy directory: #{deploy_dir}"
    dir "#{deploy_dir}/current/"
    file "#{deploy_dir}/current/script/foreverb-cron.rb"
    log  "#{deploy_dir}/shared/log/forever.log"
    pid "#{deploy_dir}/shared/pids/foreverb.pid"
  else
    pid "tmp/pids/foreverb.pid"
  end

  puts "Foreverb directory: #{dir}"

  every 30.minutes do 
    Blog.update_blogs
  end

  every 24.hours do 
    Blog.update_yandex_rating
  end

  every 1.hours do
      Twitter.update_stats
      Twitter.anounce
  end

  every 3.hours do
      Twitter.search_near
  end
  
  every 6.hours do
      Twitter.anounce
  end
  
  every 12.hours do
      Twitter.import_from_lists
  end

  every 24.hours do
      Twitter.unfollow_foreigns
      Twitter.clean_uncheboksared
      Twitter.export_friends
  end

  on_error do |e|
    puts "Boom raised: #{e.message}"
    Airbrake.notify(e)
  end

  on_ready do
  end
end
