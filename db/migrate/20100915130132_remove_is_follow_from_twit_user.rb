class RemoveIsFollowFromTwitUser < ActiveRecord::Migration
  def self.up
    remove_column :twit_users, :is_follow
    add_index :twit_users, [:state, :is_cheboksary]
  end

  def self.down
    add_column :twit_users, :is_follow, :boolean
  end
end
