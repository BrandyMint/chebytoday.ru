class AddDefaultsToTwitUsers < ActiveRecord::Migration
  def self.up
    change_column_default :following, :twit_users, :false
    change_column_default :cheboksary, :twit_users, :false
  end

  def self.down
  end
end
