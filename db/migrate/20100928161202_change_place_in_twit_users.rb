class ChangePlaceInTwitUsers < ActiveRecord::Migration
  def self.up
    change_column :twits, :place, :text
  end

  def self.down
  end
end
