# encoding: utf-8
 
namespace :twitter do
  
  # desc "Import users from other lists."
  # task :import_lists => :environment do
  #   t=Twitter::Chebytoday.new
  #   t.import_lists
  # end

  # desc "Update homeline statuses"
  # task :update_homeline => :environment do
  #   t = Twitter::Chebytoday.new()
  #   t.update_homeline
  # end

  # desc "Update cheboksary hashtag"
  # task :update_cheboksary => :environment do
  #   t = Twitter::Chebytoday.new()
  #   t.update_cheboksary
  
  # end
  
  desc "Update all"
  task :update => [:update_statuses, :import_users, :check_newbies, :check_cheboksary, :check_pull]
  #Затем. зафолловить всех listed и разослать письма о фолловинге

  desc "Update all statuses"
  task :update_statuses => :environment do
    # 1. Пользователи находятся при поиске или загрузке статусов и создаются с status=new.
    Twit.update_statuses
  end

  desc "Update users"
  task :update_users => [:import_users, :check_newbies, :check_cheboksary, :check_pull]
  

  desc "Import users"
  task :import_users => :environment do
    # 2. Поиск пользователей по спискам и по местоположению, то сразу устанавливаем ему listed
    #    и заносим в список.
    TwitUser.import_users
  end

  desc "Check newbies"
  task :check_newbies => :environment do
    # 3. Просматриваются все пользователи с status=new и проверяются с 
    #    предварительно загруженным списком chebytoday/list.
    #    Если пользователь в списке есть. Ставится status=listed (is_cheboksary=true автоматом)
    #    Если пользователя в списке нет, ставим status=pull и заносим в список chebytoday/pull
    TwitUser.check_newbies
  end

  desc "Check chebytoday/cheboksary list"
  task :check_cheboksary => :environment do
    # 5. Просматриваются все пользователи в списке chebytoday/list и делаем им listed и is_cheboksary
    TwitUser.check_cheboksary_list
  end

  desc "Check pull list"
  task :check_pull => :environment do
    # 6. Просматриваем chebytoday/pull. Если его нет со status=pull то делаем ему foreign. 
    #    Если в списке его нет, а в таблице есть, то делаем ему listed.
    TwitUser.check_pull_list
  end

  # desc "Search for users"
  # task :search => :environment do
  #   @@chebytoday.search_users_from_cheboksary(50)
  #   @@chebytoday.import_my_members
  #   TwitUser.check_newbies
  # end

  # desc "Import members from lists. Do twitter:follow after this"
  # task :import_members => :environment do
  #   @@chebytoday.import_from_list('pismenny','cheboksary')
  #   @@chebytoday.import_from_list('Radanisk','cheboksary')
  #   # @@chebytoday.search_users_from_cheboksary
  #   @@chebytoday.import_my_members
  #   TwitUser.check_newbies
  # end


  # desc "Load members to local db"
  # task :load_members => :environment do
  #   t=Twitter::Chebytoday.new
  #   t.my_members.each {  |m|
  #     if user=User.find_by_twitter_id(m.id)
  #       p "Update #{m.screen_name}"
  #       user.update_from_twitter(m)
  #     else
  #       p "Add #{m.screen_name}"
  #       User.create_from_twitter(m)
  #     end
  #   }
    
  # end
end

