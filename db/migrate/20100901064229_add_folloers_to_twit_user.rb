class AddFolloersToTwitUser < ActiveRecord::Migration
  def self.up
    add_column :twit_users, :favourites_count, :integer
    add_column :twit_users, :followers_count, :integer
    
  end

  def self.down
    remove_column :twit_users, :followers_count
    remove_column :twit_users, :favourites_count
  end
end
