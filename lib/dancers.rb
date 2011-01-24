# -*- coding: utf-8 -*-

require 'lib/chebytoday'

class Dancer < LoopDance::Dancer

  disable_autostart

  def wrapper(&block)
    begin
      block.call
    rescue => e
      Notifier.message_error(e).deliver
    end
  end
  
  every 30.minutes do 
    Blog.update_blogs
  end
  

  every 3.hours do
    wrapper do
      Twitter.import_from_lists
    end
  end

  every 24.hours do
    wrapper do
      Twitter.export_friends
    end
  end


  
end
