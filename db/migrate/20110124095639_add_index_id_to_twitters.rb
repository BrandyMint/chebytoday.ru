class AddIndexIdToTwitters < ActiveRecord::Migration
  def self.up
    add_index :twitters, :id, :unique=>true
  end

  def self.down
  end
end
