class AddNameToTwitUser < ActiveRecord::Migration
  def self.up
    add_column :twit_users, :name, :string
  end

  def self.down
    remove_column :twit_users, :name
  end
end
