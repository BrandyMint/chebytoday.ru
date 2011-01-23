# -*- coding: utf-8 -*-

require 'lib/twitter/chebytoday'

class Dancer < LoopDance::Dancer

  disable_autostart
  
  every 30.minutes do 
    Blog.update_blogs
    Twit.update_statuses
    TwitUser.update_users
  end
  
end
