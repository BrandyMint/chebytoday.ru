# -*- coding: utf-8 -*-

require 'lib/twitter/chebytoday'

class Dancer < LoopDance::Dancer
  
  every 5.minutes do
    Twit.update_statuses
  end

  every 30.minutes do 
    Blog.update_blogs
    TwitUser.update_users
  end
  
end
