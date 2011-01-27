# -*- coding: utf-8 -*-

module Grackle
  # Когда пользователь нас заблокировал отфолловинга
  class BlockedFollowing < StandardError
  end  
  
class Chebytoday


    attr_reader :client
    #cattr_reader :instance
  
    def initialize
      @client = Grackle::Client.new(:auth=>{
                                      :type=>:oauth,
                                      :consumer_key=>APP_CONFIG[:twitter]['consumer_key'], :consumer_secret=>APP_CONFIG[:twitter]['consumer_secret'],
                                      :token=>APP_CONFIG[:twitter]['oauth_token'], :token_secret=>APP_CONFIG[:twitter]['oauth_token_secret']
                                    },
                                    :auto_append_ids=>false)
      @@instance=self
      @friends=[]
    end
    
    # def self.client
    #   instance.client
    # end

    def logger
      ActiveSupport::LogSubscriber::logger
    end


    ## Методы по работы с twitter
    
    def get_user( h )
      begin
        client.users.show? h #:screen_name=>screen_name
      rescue Grackle::TwitterError => e   # TwitterError
        # raise Twitter::BlockedFollowing.new if
        #   e.message=~/Could not follow user: You have been blocked from following this account at the request of the user/
        raise e unless e.status==404 || e.status==403 || e.message=~/User has been suspended|Connection reset by peer|Unable to decode|Rate limit/
          #Notifier.message_error(e).deliver
        # Notifier.message_error(e).deliver unless e.message=~/User has been suspended/
        nil
      rescue => e
        # Notifier.message_error(e).deliver
        raise e
      end
    end

    
    # def update_statuses(since_id)
    #   h={:count=>200,:per_page=>200,:since_id=>since_id}
    #   logger.info "Get homeline, since #{h[:since_id]}"
    #   wrapper do
    #     c=client.chebytoday.lists.cheboksary.statuses?(h).each {  |t|
    #       Twit.create_from_twitter(t) unless t.empty? # незнаю почемуто иногда возаращает только пустой хеш
    #     }.count
    #     logger.info "  statuses created: #{c}" if c>0
    #   end
    # end
    
    # def update_search_statuses(since_id)
    #   #c=Twitter::Search.new('#cheboksary').since(since || 0).per_page(100).fetch().results.
    #   wrapper do
    #     client.saved_searches?.each { |s|
    #       logger.info "Search for #{s.query}, since #{since_id}"
    #       c = client[:search].search?(:since_id=>since_id,
    #         :q => s.query).results.each { |t|
    #         Twit.create_from_twitter(t,s.query)
    #       }.count
    #       logger.info "  statuses created: #{c}" if c>0
    #     }
    #   end
    # end

    def search_near_users(page)
      client[:search].search?(
        :geocode=>'56.1374511,47.2440299,20.0km',
        :result_type=>'recent',
        :page=>page,
        :q=>'near:cheboksary within:10km'
        ).results
    end
    
    def get_lists
      lists=[]
      cursor=-1
      begin
        list = client._('chebytoday').lists.subscriptions? :cursor => cursor
        lists = lists + list.lists
        cursor=list.next_cursor
      end while list.next_cursor>0
      lists
    end
    
    def get_members_of(uri)
      members=[]
      cursor=-1
      uri.gsub!(/^\//,'')
#      wrapper do
      begin
        list = client._(uri).members?({ :cursor => cursor })
        members = members + list.users
        cursor=list.next_cursor
      end while list.next_cursor>0
 #     end
      members 
    end
    
    # def my_members(reload=false)
    #   return @my_members=get_members_of('chebytoday','cheboksary') if reload
    #   @my_members or @my_members=get_members_of('chebytoday','cheboksary')
    # end
    
    # def add_member(user,list_name='cheboksary')
    #   logger.info "    add #{user.screen_name} to list #{list_name}"
    #   wrapper do
    #     client.chebytoday._(list_name).members!({:id=>user.id})
    #     my_members << user if list_name=='cheboksary'
    #   end
    # end                         #- 

    def remove_from_list(user,list_name='cheboksary')
      logger.info "    remove #{user.screen_name} from list #{list_name}"
#      wrapper do 
      client.chebytoday._(list_name).members!( :id=>user.id, :__method=>:delete)
      #end
    end

    def update_status(status)
      logger.info "Update status to '#{status}'"
      #wrapper do
      client.statuses.update!({:status=>status})
      #end
    end

    # def follow(user)
    #   logger.info "    Follow to '#{user.screen_name}'"
    #   wrapper do
    #     client.friendships.create!({:screen_name=>user.screen_name,:follow=>true})
    #     @friends.push user
    #     true
    #   end
    # rescue Grackle::BlockedFollowing => e
    #   logger.warn "User blocked #{user.screen_name}"
    #   false
    # end

     def unfollow(user)
       logger.info "    Unfollow to '#{user.screen_name}'"
       client.friendships.destroy!({:user_id=>user.id})
     end

    def friends( user )
      cursor=-1
      friends = []
      begin 
        list = client.statuses.friends?({ :screen_name=>user.screen_name, :cursor=>cursor })
        friends = friends + list.users
        cursor = list.next_cursor
      end while list.next_cursor>0
      friends
    end

    def send_direct_message(user, message)
      logger.info "    Send direct message to '#{user.screen_name}'"
      #wrapper do
      client.direct_messages.new!({:screen_name=>user.screen_name, :text=>message})
      #end
    end
    
  end
  
end
