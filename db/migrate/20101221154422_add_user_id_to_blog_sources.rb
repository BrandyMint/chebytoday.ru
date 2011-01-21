class AddUserIdToBlogSources < ActiveRecord::Migration
  def self.up
    add_column :blog_sources, :user_id, :integer
  end

  def self.down
    remove_column :blog_sources, :user_id
  end
end
