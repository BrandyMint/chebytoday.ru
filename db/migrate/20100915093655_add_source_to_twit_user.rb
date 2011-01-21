class AddSourceToTwitUser < ActiveRecord::Migration
  def self.up
    add_column :twit_users, :source, :string
  end

  def self.down
    remove_column :twit_users, :source
  end
end
