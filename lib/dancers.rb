# -*- coding: utf-8 -*-

require 'lib/chebytoday'

class Dancer < LoopDance::Dancer

  @start_timeout = 60
  @stop_timeout = 60
  @log_file_activity_timeout = 20
  @trap_signals = false

  class << self
    def wrapper(&block)
      block.call
    rescue => e
      Notifier.message_error(e).deliver
    end
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

  every 30.minutes do 
    Blog.update_blogs
  end


end
