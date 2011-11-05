#!/usr/bin/env ruby
puts 'Load rails environment..'
require File.expand_path('../../config/application', __FILE__)

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
    file "#{deploy_dir}/current/script/foreverb-cron"
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
    wrapper do
      Twitter.update_stats
      Twitter.anounce
    end
  end

  every 3.hours do
    wrapper do
      Twitter.search_near
    end
  end
  
  every 6.hours do
    wrapper do 
      Twitter.anounce
    end
  end
  
  every 12.hours do
    wrapper do
      Twitter.import_from_lists
    end
  end

  every 24.hours do
    wrapper do
      Twitter.unfollow_foreigns
      Twitter.clean_uncheboksared
    end
    wrapper do
      Twitter.export_friends
    end
  end

  on_error do |e|
    puts "Boom raised: #{e.message}"
    Airbrake.notify(e)
  end

  on_ready do
  end
end
