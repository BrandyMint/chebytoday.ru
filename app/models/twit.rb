# -*- coding: utf-8 -*-
class Twit < ActiveRecord::Base
  
  attr_accessible :text, :created_at, :favorited, :place, :retweeted_status, :geo, :truncated, :source, :contributors, :coordinated, :twit_user_id, :in_reply_to_user_id, :in_reply_to_status_id, :in_reply_to_screen_name

  acts_as_taggable

  #set_primary_key :id

  scope :ordered, order('id desc').includes(:twit_user)
  
  belongs_to :twit_user

  def self.last_status_id
    maximum(:id) || 100000
  end

  def self.update_statuses
    since_id=Twit.last_status_id # ? Twit.last_status_id : nil
    @@chebytoday.update_statuses(since_id)
    @@chebytoday.update_search_statuses(since_id)
  end

  # Создаем статус и автоматически чувака с is_cheboksary=true

  def self.create_from_twitter(twit,search_tag='')
    return nil if find_by_id(twit.id)
    if twit.user_id || twit.user
      twit_user = twit.user ? TwitUser.find_or_create(twit.user,'status_update#2') : TwitUser.find(twit.user_id)
    else
      #pp twit
      unless twit_user = TwitUser.find_by_screen_name(twit.screen_name=twit.from_user)
        TwitUser.logger.info "  Query user #{twit.screen_name}"
        twit_user = TwitUser.find_or_create(@@chebytoday.get_user(twit.screen_name),'status_update#1')
      end
    end
    h={}
    #Twit.attr_accessible.to_a.map { |k| h[k]=twit[k] }
    Twit.attr_accessible.to_a.map { |k| h[k]=twit.send(k) }
    t = new h
    t.id = twit.id
    t.twit_user = twit_user
    t.update_tags
    t.save!
  end

  def update_tags
    tags=[]
    self.text.gsub(/\#(\w+)/) { |tag|
      tags << tag.downcase
    }
    self.tag_list= tags * ', '
  end
  
end
