# -*- coding: utf-8 -*-
class Twitter < ActiveRecord::Base


  STATE = [ :cheboksary, :pull, :foreign ]

  state_machine :initial => :pull do
    state :cheboksary, :pull, :foreign
  end

  LIST_STATE = [ :listed, :none, :blocked ]

  state_machine :list_state, :initial => :none do
    state :listed, :none, :blocked
  end

  class << self
    def import_from_twit_users
      destroy_all
      TwitUser.all.map do |t|
        h = {}
        %w[ screen_name name profile_image_url
          friends_count statuses_count favourites_count listed_count
          location created_at updated_at ].each do |i|
        h[i] = t.attributes[i.to_s]
        end
        
        h[:source] = t.source || t.cheboksary_source || ''
        h[:twitter_created_at] = t.twiter_created_at
        h[:anounced_at] = t.created_at if t.is_anounced
        
        w = new h
        w.id = t.id
        # cheboksary, pull, foreign
        w.state = "cheboksary" if w.is_cheboksary_granted? || w.cheboksary?
        w.save!
      end
    end
  end

  def is_location_cheboksary?
    self.location=~/novochebok|cheboks|chuvashi|ебокса|уваши|tsjebok|.*56\.1.*47\.4.*/i
  end
  
  def is_cheboksary_granted?
    is_location_cheboksary? || source=~/cheboksary|chuvash/i
  end
  
end

# == Schema Information
#
# Table name: twitters
#
#  id                 :integer(8)      primary key
#  screen_name        :string(255)     not null
#  is_cheboksary      :boolean         default(FALSE), not null
#  name               :string(255)
#  profile_image_url  :string(255)
#  friends_count      :integer         default(0), not null
#  statuses_count     :integer         default(0), not null
#  favourites_count   :integer         default(0), not null
#  listed_count       :integer         default(0), not null
#  location           :string(255)
#  source             :string(255)     not null
#  is_source_granted  :string(255)     default("f"), not null
#  state              :string(255)     not null
#  list_state        :string(255)     not null
#  twitter_created_at :datetime        not null
#  anounced_at        :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

