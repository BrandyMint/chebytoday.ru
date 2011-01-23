class AddSourceIndexToTwitters < ActiveRecord::Migration
  def self.up
    add_index :twitters, :source
  end

  def self.down
  end
end
