class AddIsFollowedToTwitUser < ActiveRecord::Migration
  def self.up
    add_column :twit_users, :is_follow, :boolean, :default=>false
    add_column :twit_users, :is_anounced, :boolean, :default=>false
    add_column :twit_users, :followed_at, :timestamp
  end

  def self.down
    remove_column :twit_users, :followed_at
    remove_column :twit_users, :is_anounced
    remove_column :twit_users, :is_follow
  end
end
