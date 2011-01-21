class AddTwitterCreatedAtToTwitUser < ActiveRecord::Migration
  def self.up
    add_column :twit_users, :twiter_created_at, :timestamp
  end

  def self.down
    remove_column :twit_users, :twiter_created_at
  end
end
