class AddFollowersCountToTwitters < ActiveRecord::Migration
  def self.up
    add_column :twitters, :followers_count, :integer, :null=>false, :default=>0
    add_index :twitters, :followers_count
  end

  def self.down
    remove_column :twitters, :followers_count
  end
end
