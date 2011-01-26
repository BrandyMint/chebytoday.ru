# -*- coding: utf-8 -*-
class Twitter < ActiveRecord::Base

  validates :screen_name, :presence => true, :uniqueness => true
  validate :validate_twitter, :if  =>  :adding_from_web?

  scope :cheboksary, where( :state => :cheboksary ) # .order("friends_count desc")
  scope :pull, where( :state => :pull )
  scope :best, cheboksary.limit(5)
  scope :other, where("state<>'cheboksary'")
  scope :newbies, cheboksary.order('created_at desc').limit(7)


  scope :to_follow, where( :list_state => :none)
  scope :listed, where( :list_state => :listed)

  scope :to_anounce, cheboksary.where( "anounced_at is NULL" )
  
  scope :to_update, cheboksary.listed.order('updated_at asc').limit(50)
  
  has_many :twits

  # TODO
  # Если добавляют с веба и есть статус foreign, то менять его на pull и ставить источник web

  IS_CHEBOKSARY = [false, true]

  STATE = %w( cheboksary pull foreign )
  #STATE = %w(pending encoding encoded error published)
  #validates_inclusion_of :state, :in => STATE
  
   state_machine :initial => :pull do
     state :cheboksary, :pull, :foreign, :unknown
   end

  LIST_STATE = %w( listed none blocked )
  # validates_inclusion_of :list_state, :in => LIST_STATE
  
  state_machine :list_state, :initial => :none do
    state :listed, :none, :blocked
   end

  class << self
    def logger
      ActiveSupport::LogSubscriber::logger
    end
    # def import_from_twit_users
    #   # destroy_all
    #   TwitUser.all.map do |t|
    #     next if Twitter.find_by_id t.id
    #     h = {}
    #     %w[ screen_name name profile_image_url
    #       friends_count statuses_count favourites_count listed_count
    #       location created_at updated_at ].each do |i|
    #     h[i] = t.attributes[i.to_s]
    #     end
        
    #     h[:source] = t.source || t.cheboksary_source || ''
    #     h[:twitter_created_at] = t.twiter_created_at
    #     h[:anounced_at] = t.created_at if t.is_anounced
        
    #     w = new h
    #     w.id = t.id
    #     # cheboksary, pull, foreign
    #     w.to_cheboksary 'imported' if w.is_cheboksary_granted? || w.cheboksary?
    #     w.save!
    #   end
    # end

    def update_stats
      to_update.each do |twitter|
        puts "Update @#{twitter.screen_name}"
        twitter.wrapper do
          user = @@chebytoday.client.users.show? :id => twitter.id
          twitter.update_from_twitter user if user
          twitter.load_friends
        end
        break if twitter.followers_count>5000
      end
    end

    def fuck_foreigns
      pull.select do |t|
        if (t.source=~/search|status_update/ || t.source.empty?) && t.location && t.location.mb_chars.downcase=~/Moscow|Samara|Kazan|Peters|Yoshkar|Omsk|Kazan|Укра|Minsk|казань|москва|ukraine|golen|днепропетр|астраха|gomel|красноярск|kiev|ekaterin|tiraspol|chernigov|gukovo|bryansk|perm|tula|irkutsk|novosib|йошка/ui
          t.update_attribute :state, 'foreign'
        end
      end
    end

    def fuck_duplicates
      Twitter.select("id, count(*) as count").group(:id).map do |t|
        next if t.count.to_i==1
        p "#{t.id}(#{t.count})"
        if twitter = @@chebytoday.get_user( :id=>t.id )
          Twitter.where( :id=>t.id ).each do |ta|
            unless ta.screen_name == twitter.screen_name
              p "remove #{ta.screen_name}"
              ta.delete_by_screen_name
            end
          end
        else
          p "No users with this ID found"
        end
      end
    end

    # def import_friends
    #   @@chebytoday.friends(true).each do |t|
    #     twitter = find_or_create t, 'friends'
    #     twitter.update_attribute :list_state, 'listed'
    #   end
    # end

    def unfollow_foreigns
      other.listed.map &:unfollow
    end

    def clean_uncheboksared
      @@chebytoday.friends(find_by_screen_name 'chebytoday').each do |t|
        if twitter = find_by_id( t.id )
          #twitter = find_or_create t, 'friends', false
          twitter.unfollow unless twitter.cheboksary?
        end
      end
    end

    def export_friends
      cheboksary.to_follow.each do |twitter|
        next if twitter.screen_name=='chebytoday'
        twitter.wrapper do
          logger.info "    Follow to '#{twitter.screen_name}'"
          @@chebytoday.client.friendships.create!({:screen_name=>twitter.screen_name, :follow=>true})
          twitter.update_attribute(:list_state, 'listed')
        end
      end
    end

    def import_from_lists
      import_from_list(
        OpenStruct.new( :uri=>'/chebytoday/cheboksary', :full_name=>'@chebytoday/cheboksary' ),
        true)
      @@chebytoday.get_lists.each do |list|
        import_from_list list
      end
      # import_from_list('she_stas','che')
      # import_from_list('jonny3D_ru','cheboksary')
      # import_from_list('el_s0litari0','cheboksary')
      # import_from_list('Masher_Kopteva','cheboksary')
      # import_from_list('blackfox_lola','che')
      # import_from_list('lena_trish','cheboksary-chuvashia')
      # import_from_list('pismenny','cheboksary')
      # import_from_list('Radanisk','cheboksary')
      # import_from_list('lexlarri','cheboksary')
      # import_from_list('IrinaDm','chuvashia')
      # import_from_list('svoydom21','cheboksary')
      # import_from_list('michaelgruzdev','hometown')
      0
    end

    def import_from_list(list, remove = false)
      logger.info "Get members of #{list.uri}"
      @@chebytoday.get_members_of( list.uri ).each { |t|
        twitter = find_or_create( t, list.full_name )
        @@chebytoday.remove_from_list twitter if remove
      }
      0
    end

    def find_or_create( twit_user, source, grand = true )
      twitter = find_by_id( twit_user.id ) || Twitter.new( :source => source )
      twitter.update_from_twitter twit_user
      twitter.to_cheboksary source if grand && !twitter.cheboksary?
      twitter.save!
      twitter
    end

    def is_cheboksary?( location )
      (location && location.mb_chars.downcase=~/n-check|nchk|novochebok|cheboxa|cheboks|chuvashi|ебокса|чуваш|tsjebok|.*56\.1.*47\.2.*/i) ? true : false
    end
  
    def search_near(pages=10)
      puts "Search for users near cheboksary"
      #http://search.twitter.com/search?geocode=56.1374511%2C47.2440299%2C50.0km&max_id=21075586190&page=3&q=+near%3Acheboksary+within%3A50km#
      #.since(h[:since_id] || 0)
      #16776 den_rad
      c=0
      for page in 1..pages do
        r = @@chebytoday.search_near_users(page)
        if r        
          r.each { |t|
            if is_cheboksary? t.location
              user = @@chebytoday.get_user :id=>t.from_user_id
              if user && is_cheboksary?( user.location )
                puts "Add user #{user.id}/#{user.screen_name} from #{user.location}"
                find_or_create( user, 'search#near(from)')
                c+=1
              end
              user = @@chebytoday.get_user :id=>t.to_user_id
              if user && is_cheboksary?( user.location )
                puts "Add user #{user.id}/#{user.screen_name} from #{user.location}"
                find_or_create( user, 'search#near(to)')
                c+=1
              end
            end
          }
        else
          break
        end
      end
      puts "  new users found: #{c}" if c>0
    end
    
    def anounce
      return if to_anounce.count==0
      message="Новые чебоксарцы: "
      to_anounce.each { |user|
        str=message[-2,1]==':' ? '@' : ", @"
        str+=user.screen_name
        break if message.length+str.length>120
        message+=str
        user.update_attribute(:anounced_at, Time.now())
        #pp user.screen_name
      }
      puts "Anounce: #{message}"
      @@chebytoday.update_status(message)
    end
  end
  
  def load_friends
    cursor=-1
    c=0
    begin
      print '.'
      list = @@chebytoday.client.statuses.friends?({ :screen_name=>self.screen_name, :cursor=>cursor })
      list.users.each do  |friend|
        if self.class.is_cheboksary?( friend.location )
          unless self.class.find_by_id friend.id
            puts "Add user @#{friend.screen_name} from #{friend.location} is a friend of @#{screen_name}"
            self.class.find_or_create( friend, "@#{friend.screen_name}#friends" )
            c+=1
          end
        end
      end
      cursor = list.next_cursor
    end while list.next_cursor>0
    puts "Friends loaded: #{c}" if c>0
  end

  def is_cheboksary
    self.class.is_cheboksary? self.location
  end

  def to_s
    screen_name
  end

  def to_cheboksary( source='manual', force=false )
    if state=='foreign'
      puts "Can't move to cheboksary foreigned user @#{self.screen_name} by #{source}"
    else
      puts "to cheboksary @#{self.screen_name} by #{source}"
      update_attribute :state, 'cheboksary'
      update_attribute :source, source
    end
  end

  def to_blocked
    update_attribute(:list_state, 'blocked')
  end

  def to_pull
    was_state = state
    update_attribute :state, 'pull'
    unfollow if was_state=='cheboksary'
  end

  def to_foreign
    was_state = state
    update_attribute :state, 'foreign'
    unfollow if was_state=='cheboksary'
  end
  
  def to_unknown
    was_state = state
    update_attribute :state, 'unknown'
    unfollow if was_state=='cheboksary'
  end

  def to_none
    update_attribute(:list_state, 'none')
    update_attribute(:state, 'foreign') if cheboksary?
  end

  # def is_cheboksary_granted?
  #   is_location_cheboksary? || source=~/cheboksary|chuvash/i
  # end

  def unfollow
    puts "Unfollow '#{screen_name}'"
    @@chebytoday.unfollow self
    to_none
  rescue Grackle::TwitterError => e
    if e.message=~/You are not friends/
      to_none
      # elsif e.message=~/blocked|Could not follow user: Sorry, this account has been suspended/
      #   twitter.update_attribute(:list_state, 'blocked')
      # elsif e.message=~/Not found/
      #   twitter.delete_by_screen_name
    else
      raise e
    end
  end

  def admin_links
    ( "<a href=\"/admin/twitters/to_cheboksary/#{id}\">cheby</a> | " +
      "<a href=\"/admin/twitters/to_foreign/#{id}\">foreign</a> | " +
      "<a href=\"/admin/twitters/to_unknown/#{id}\">unknown</a> | " +
      "<a href=\"http://twitter.com/#{screen_name}\">@#{screen_name}</a>"
      ).html_safe
  end

  def delete_by_screen_name
    self.class.delete_all :screen_name => self.screen_name
  end

  
  def update_from_twitter( twitter )
    Twitter.logger.info("update_from_twitter #{twitter.screen_name}")
    
    h = {
      :profile_image_url => twitter.profile_image_url,
      :location => twitter.location,
      :statuses_count => twitter.statuses_count,
      :friends_count => twitter.friends_count,
      :favourites_count => twitter.favourites_count,
      :followers_count => twitter.followers_count,
      :listed_count => twitter.listed_count,
      :twitter_created_at => twitter.created_at,
      :name => twitter.name,
      :screen_name => twitter.screen_name
      #      :following => twitter.following,
      # :source => src
    }

    self.id = twitter.id unless self.id
    if twitter.following && !self.listed?
      self.update_attribute :list_state, 'listed'
      self.to_cheboksary 'autolister' unless self.cheboksary?
    end
    if !twitter.following && self.listed?
      self.update_attribute :list_state, 'none'
    end
    self.touch
    self.update_attributes h
    self
  end

  def wrapper( &block )
    block.call
  rescue Grackle::TwitterError => e
    if e.message=~/already on your list/
      update_attribute(:list_state, 'listed')
    elsif e.message=~/blocked|Could not follow user: Sorry, this account has been suspended/
      to_blocked
    elsif e.message=~/Not found/
      delete_by_screen_name
    else
      raise e
    end
  end
  

  private

  def adding_from_web?
    !self.id
    #    !(self.profile_image_url || self.statuses_count)
  end
  
  def validate_twitter
    begin
      @twitter_user = @@chebytoday.get_user(self.screen_name)
    rescue StandardError => e # Twitter::TwitterError  =>  e   # TwitterError
      errors.add(:screen_name, "Ошибка соединения с твиттером")
    end
    
    if @twitter_user
      if t = Twitter.find_by_screen_name( @twitter_user.screen_name )
        unless t.state=='cheboksary'
          t.to_pull
          t.update_attribute :source, 'web'
          t.save!
          errors.add(:screen_name, "и ожидает ручной проверки")
        end
      else
        set_from_twitter( @twitter_user, 'web' )
      end
    else
      errors.add(:screen_name, "Нет такого пользователя в твиттере")
    end
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

