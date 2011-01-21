class AddCheboksrySourceToTwitUsers < ActiveRecord::Migration
  def self.up
    add_column :twit_users, :cheboksary_source, :string
  end

  def self.down
    remove_column :twit_users, :cheboksary_source
  end
end
