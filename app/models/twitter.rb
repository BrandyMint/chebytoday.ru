# -*- coding: utf-8 -*-
class Twitter < ActiveRecord::Base

  validates :screen_name, :presence => true, :uniqueness => true
  validate :validate_twitter, :if  =>  :adding_from_web?

  scope :cheboksary, where( :state => :cheboksary ) # .order("friends_count desc")
  scope :others, where("state<>'cheboksary'")
  scope :best, cheboksary.limit(5)
  scope :newbies, cheboksary.order('created_at desc').limit(7)
  
  has_many :twits

  # TODO
  # Если добавляют с веба и есть статус foreign, то менять его на pull и ставить источник web


  STATE = %w( cheboksary pull foreign )
  #STATE = %w(pending encoding encoded error published)
  validates_inclusion_of :state, :in => STATE
  
  # state_machine :initial => :pull do
  #   state :cheboksary, :pull, :foreign
  # end

  LIST_STATE = %w( listed none blocked )
  validates_inclusion_of :list_state, :in => LIST_STATE
  
  # state_machine :list_state, :initial => :none do
  #   state :listed, :none, :blocked
  # end

  class << self
    def logger
      ActiveSupport::LogSubscriber::logger
    end
    def import_from_twit_users
      # destroy_all
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
        w.to_cheboksary if w.is_cheboksary_granted? || w.cheboksary?
        w.save!
      end
    end

    def fuck_foreigns
      others.select do |t|
        if (t.source=~/search|status_update/ || t.source.empty?) && t.location && t.location.mb_chars.downcase=~/Moscow|Samara|Kazan|Peters|Yoshkar|Omsk|Kazan|Укра|Minsk|казань/i
          t.update_attribute :state, 'foreign'
        end
      end
    end
    
  end

  def to_cheboksary
    update_attribute :state, 'cheboksary'
  end

  def to_pull
    update_attribute :state, 'pull'
  end

  def to_foreign
    update_attribute :state, 'foreign'
  end

  def is_location_cheboksary?
    self.location && self.location.mb_chars.downcase=~/n-check|nchk|novochebok|cheboxa|cheboks|chuvashi|ебокса|чуваш|tsjebok|.*56\.1.*47\.4.*/i
  end
  
  def is_cheboksary_granted?
    is_location_cheboksary? || source=~/cheboksary|chuvash/i
  end

  def admin_links
    ( "<a href=\"/admin/twitters/to_cheboksary/#{id}\">cheby</a> | " +
      "<a href=\"/admin/twitters/to_foreign/#{id}\">foreign</a> | " +
      "<a href=\"http://twitter.com/#{screen_name}\">@#{screen_name}</a>"
      ).html_safe
  end

  private

  def adding_from_web?
    !self.id
    #    !(self.profile_image_url || self.statuses_count)
  end
  
  def validate_twitter
    begin
      twitter = @@chebytoday.get_user(self.screen_name)
    rescue StandardError => e # Twitter::TwitterError  =>  e   # TwitterError
      errors.add(:screen_name, "Ошибка соединения с твиттером")
    end
    
    if twitter
      if t = Twitter.find_by_screen_name( twitter.screen_name )
        unless t.state=='cheboksary'
          t.to_pull
          t.update_attribute :source, 'web'
          t.save!
          errors.add(:screen_name, "и ожидает ручной проверки")
        end
      else
        set_from_twitter( twitter, 'web' )
      end
    else
      errors.add(:screen_name, "Нет такого пользователя в твиттере")
    end
  end

  def set_from_twitter( twitter=nil, src=nil )
    
    TwitUser.logger.info("set_from_twitter #{twitter.screen_name} #{!twitter} #{!self.twitter_created_at} #{!twitter.created_at}") if twitter

    if twitter
      twitter = @@chebytoday.get_user( twitter.screen_name )
      # А зачем? Пущай заново берет. А то search#near глючные валязят.
      #if !self.twiter_created_at ||
      #  !twitter.created_at
    else 
      twitter = @@chebytoday.get_user( screen_name )
    end
    
    # raise "Can't get user #{twitter.screen_name} from #{src}" unless twitter
    return nil unless twitter
    
    h = {
      :profile_image_url => twitter.profile_image_url,
      :location => twitter.location,
      :statuses_count => twitter.statuses_count,
      :friends_count => twitter.friends_count,
      :favourites_count => twitter.favourites_count,
      :followers_count => twitter.followers_count,
      :following => twitter.following,
      :twiter_created_at => twitter.created_at,
      :listed_count => twitter.listed_count,
      :name => twitter.name
    }

    # Новый зверь
    unless self.id
      self.id = twitter.id 
      h[:screen_name] = twitter.screen_name 
      h[:source] = src
    end

    # h[:is_follow] = true if src=='following' || cheboksary_sure
    # h[:state] = 'pull' поумолчанию

    self.attributes = h

    self
  end


  
end



# == Schema Information
#
# Table name: twitters
#
#  id                 :integer(8)      primary key
#  screen_name        :string(255)     not null
#  name               :string(255)
#  profile_image_url  :string(255)
#  friends_count      :integer         default(0), not null
#  statuses_count     :integer         default(0), not null
#  favourites_count   :integer         default(0), not null
#  listed_count       :integer         default(0), not null
#  location           :string(255)
#  source             :string(255)     not null
#  state              :string(255)     not null
#  list_state         :string(255)     not null
#  twitter_created_at :datetime        not null
#  anounced_at        :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  followers_count    :integer         default(0), not null
#

