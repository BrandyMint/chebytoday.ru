class RenameTwitUserIdToTwitterIdInTwits < ActiveRecord::Migration
  def self.up
    rename_column :twits, :twit_user_id, :twitter_id
  end

  def self.down
    rename_column :twits, :twitter_id, :twit_user_id
  end
end
