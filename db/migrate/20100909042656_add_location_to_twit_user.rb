class AddLocationToTwitUser < ActiveRecord::Migration
  def self.up
    add_column :twit_users, :location, :string
  end

  def self.down
    remove_column :twit_users, :location
  end
end
