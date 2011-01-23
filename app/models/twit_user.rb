# -*- coding: utf-8 -*-

# ActiveRecord::Base.logger 
#require 'twitter'
class TwitUser < ActiveRecord::Base
  attr_accessible :screen_name, :profile_image_url, :is_cheboksary, :statuses_count, :friends_count, :favourites_count, :following, :followers_count, :twiter_created_at, :listed_count, :name, :location, :source, :is_follow, :state

  STATE = [ :cheboksary,:blocked, :pull, :foreign ]

  # TODO is_cheboksary - значит локейшин точно чебоксарский /cheboks/
  
  has_many :twits

  validates :screen_name, :presence => true, :uniqueness => true
  
  validate :validate_twitter, :if  =>  :adding_from_web?
  
  #scope :newbies, where( :state => 'new' )
  
  #scope :cheboksary, where( :is_cheboksary => true ) # .order("friends_count desc")
  
  scope :cheboksary, where( :state => :cheboksary ) # .order("friends_count desc")
  scope :cheboksary_and_blocked, where( "state=? or state=?", :cheboksary, :blocked ) # .order("friends_count desc")
  scope :cheboksary_location, where( :is_cheboksary => true )

  scope :foreigns, where( :state => :foreign ) # .order("friends_count desc")
  scope :pull, where( :state => :pull ) # .order("friends_count desc")

  
  scope :best, cheboksary.limit(5)
  
  scope :new_listed, cheboksary.order('created_at desc').limit(7)
  # scope :pulled, where( :state => 'pull' )
  # scope :all_listed, where( :state => 'listed' )
  
  scope :not_anounced, cheboksary.where( "not is_anounced or is_anounced is NULL" ).order( 'created_at asc' ).limit(20)
  
  # scope :not_followed, where( "state='listed' and (not is_follow or is_follow is NULL)" )

  before_save :check_location

  def self.logger
    ActiveSupport::LogSubscriber::logger
  end

  def adding_from_web?
    !self.id
    #    !(self.profile_image_url || self.statuses_count)
  end

  def validate_twitter
    begin
      twit_user = @@chebytoday.get_user(self.screen_name)
    rescue StandardError => e # Twitter::TwitterError  =>  e   # TwitterError
    end
    
    if twit_user
      set_from_twitter( twit_user, 'web' )
    else
      errors.add(:screen_name, "Нет такого пользователя в твиттере")
    end
  end

  state_machine :initial => :pull do
    
    state :cheboksary, :blocked, :pull, :foreign

    # :blocked - пользователь нас заблокировал, не дергать

    event :state_cheboksary do
      transition any => :cheboksary
    end

    event :blocked do
      transition any => :blocked
    end

    event :pull do
      transition any => :pull
    end

    event :foreign do
      transition any => :foreign
    end

    before_transition any => :foreign do |user|
      @@chebytoday.unfollow(user) if user.following
    end
    
    after_transition any => :foreign do |user|
      user.set_from_twitter and user.save!
    end

    # before_transition any => :cheboksary do |user|
    #   unless user.following
    #     @@chebytoday.follow(user) or user.state = :blocked
    #   end
    # end

    after_transition any => :cheboksary do |user|
      unless user.following
        @@chebytoday.follow(user) or user.state = :blocked
        user.update_attribute( :followed_at, DateTime.now() )
      end
    end

    
  end

  # @chebytoday/followed - основной список твиттерян, если их фолловить/разфолловить это отражается на базе
  # @chebytoday/cheboksary - тупая копия followed
  #
  # Если пользователь добавляется с web - заносим его в pull (поумолчанию)
  #
  # Вручную через web просматриваем pull
  # - Если нравится - делаем follow
  # - Если не нравится - заносим в foreign

  def self.update_users
    load_friends
    # import to @chebytoday/cheboksary list

    import_from_list('pismenny','cheboksary')
    import_from_list('Radanisk','cheboksary')
    import_from_list('lexlarri','cheboksary')

    search_users_from_cheboksary

    cheboksary_location.where("state<>'cheboksary'").map { |u|
      u.to_cheboksary('clear')
    }
  end


  def self.remove_bads
    cheboksary.where({ :is_cheboksary=>false, :source=>'search#near' }).map { |u|
      u.foreign  unless u.location.blank?
    }
  end

  # BLocked:
  # slava_romanov
  # IAmYuliaBelka
  # chebytoday
  # alicenata
  # nyansee
  # Michalych
  # nuri_tyan
  # pogoda_ch
  # Sterlet
  
  # Берем список всех followed с твиттера и проверяем
  # - если есть в базе и статус cheboksary - OK
  # - если есть в базе и статус другой - меняем статус без реального фоллова
  # - если пользователя нет в базе - сохраняем со статусом без реального фоллова
  #
  # Берем список всех status=cheboksary
  # - Если пользователь followed - все ok
  # - Если пользоватлеь не followed, значит уносим его в foreign
  #
  def self.load_friends
    TwitUser.update_all({ :following=>false })
    @@chebytoday.friends(true).map { |twit_user|
      user = find_or_create( twit_user, 'following' )
      user.to_cheboksary("friends") unless user.cheboksary?
    }.count
    TwitUser.cheboksary.where({ :following=>false }).each { |user|
      user.foreign
    }
  end

  
  def self.anounce
    message="Новые твиттеряне в #cheboksary : "
    not_anounced.each { |user|
      str=message[-2,1]==':' ? '@' : ", @"
      str+=user.screen_name
      break if message.length+str.length>120
      message+=str
      user.update_attribute(:is_anounced,true)
      #pp user.screen_name
    }
    @@chebytoday.update_status(message)
  end

  def self.unfollow_by_location(location, force=false)
    matched = 0
    TwitUser.cheboksary.map { |user|
      if location.match( user.location )
        puts "#{user.screen_name} - #{user.location}"
        user.foreign if force
        matched += 1
      end
    }
    matched
  end


  def self.import_from_list(user_name, list_name)
    TwitUser.logger.info "Get members of #{user_name}/#{list_name}"
    @@chebytoday.get_members_of( user_name, list_name ).each { |t|
      find_or_create( t, "list/#{user_name}" ).to_cheboksary("#{user_name}/#{list_name}")
    }
  end


  def self.search_users_from_cheboksary(pages=10)
    # Чтото очень мало юзеров, проще врчную добавлять
    #base.user_search('cheboksary')
    TwitUser.logger.info "Search for users near cheboksary"
    #http://search.twitter.com/search?geocode=56.1374511%2C47.2440299%2C50.0km&max_id=21075586190&page=3&q=+near%3Acheboksary+within%3A50km#
    #.since(h[:since_id] || 0)
    #16776 den_rad
    c=0
    for page in 1..pages do
      # logger.info "Get page #{page}"
      r = @@chebytoday.search_near_users(page)
      if r        
        r.each { |t|
          p t.location
          # TwitUser.logger.info "  found #{t.from_user}"
          # find_or_create( t.from_user, 'search' )
          unless find_by_screen_name( t.from_user )
            TwitUser.logger.info "  found #{t.from_user}"
            if twit_user = @@chebytoday.get_user( t.from_user )
              user = create_from_twitter( twit_user, 'search#near' )
              # Это уже в create_from_twitter сделали
              # user.to_cheboksary("search#near") if user && user.is_location_cheboksary?
            end
            c=c+1
          end
        }
      else
        # TwitUser.logger.info "  break"
        break
      end
    end
    TwitUser.logger.info "  new users found: #{c}" if c>0
  end


  
  def self.find_or_create(twit_user, source)
    if user = find_by_screen_name( twit_user.screen_name )
      user.set_from_twitter( twit_user, source ) and user.save! if twit_user.following != user.following || !user.foreign? # нафиг нам врагов обновлять
      user
    else
      create_from_twitter( twit_user, source )
    end
  end

  
  def self.create_from_twitter(twit_user, source, cheboksary_sure=false )
    TwitUser.logger.info "  Create user #{twit_user.screen_name} / #{twit_user.id}"
    u = new()
    u.set_from_twitter( twit_user, source ) or return nil
    u.to_cheboksary("create_from_twitter-#{cheboksary_sure}-#{twit_user.following}-#{u.is_location_cheboksary?}") if cheboksary_sure || twit_user.following || u.is_location_cheboksary?
    u.save!
    u
  end

  
  def self.find_by_screen_name(screen_name)
    where("lower(screen_name) = ?", screen_name.downcase).first
  end


  # def cheboksary
  #   @@chebytoday.follow(self) or return blocked   unless following
  #   update_attribute( :state, 'cheboksary' )
  # end

  
  # сначала пользователя вносим в список /cheboksary
  # затем подписываемся на него если не подписаны и посылаем ему письмо
  
  
  def is_a_member_of_list?(list=@@chebytoday.my_members)
    res = list.detect { |u|
      u.id==self.id
    }
    !res.nil?
  end  
  
  def direct_message( message=nil )
    message ||= "Мы добавили Вас в список Чебоксарских твиттерян на http://chebytoday.ru/ где ведем рейтинг местных микро-блоггеров."
    @@chebytoday.send_direct_message(self,message)
  end

  
  def set_from_twitter( twit_user=nil, src=nil )
    
    TwitUser.logger.info("set_from_twitter #{twit_user.screen_name} #{!twit_user} #{!self.twiter_created_at} #{!twit_user.created_at}") if twit_user

    if twit_user
      twit_user = @@chebytoday.get_user( twit_user.screen_name )
      # А зачем? Пущай заново берет. А то search#near глючные валязят.
      #if !self.twiter_created_at ||
      #  !twit_user.created_at
    else 
      twit_user = @@chebytoday.get_user( screen_name )
    end
    
    # raise "Can't get user #{twit_user.screen_name} from #{src}" unless twit_user
    return nil unless twit_user
    
    h = {
      :profile_image_url => twit_user.profile_image_url,
      :location => twit_user.location,
      :statuses_count => twit_user.statuses_count,
      :friends_count => twit_user.friends_count,
      :favourites_count => twit_user.favourites_count,
      :followers_count => twit_user.followers_count,
      :following => twit_user.following,
      :twiter_created_at => twit_user.created_at,
      :listed_count => twit_user.listed_count,
      :name => twit_user.name
    }

    # Новый зверь
    unless self.id
      self.id = twit_user.id 
      h[:screen_name] = twit_user.screen_name 
      h[:source] = src
    end

    # h[:is_follow] = true if src=='following' || cheboksary_sure
    # h[:state] = 'pull' поумолчанию

    self.attributes = h

    self
  end

  def is_location_cheboksary?
    (self.location=~/novochebok|cheboks|chuvashi|ебокса|уваши|tsjebok|.*56\.1.*47\.4.*/i) ? true : false
  end

  def to_cheboksary(source)
    state_cheboksary
    update_attribute(:cheboksary_source,source)
  end
  
private

  def check_location
    self.is_cheboksary = true if is_location_cheboksary?
    true
  end
  
end
