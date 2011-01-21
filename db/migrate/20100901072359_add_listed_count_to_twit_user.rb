class AddListedCountToTwitUser < ActiveRecord::Migration
  def self.up
    add_column :twit_users, :listed_count, :integer
  end

  def self.down
    remove_column :twit_users, :listed_count
  end
end
