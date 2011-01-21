class AddArticlesCountToBlogSources < ActiveRecord::Migration
  def self.up
    add_column :blog_sources, :articles_count, :integer
    add_column :blog_sources, :articles_updated_at, :timestamp
    
  end

  def self.down
    remove_column :blog_sources, :articles_count
    remove_column :blog_sources, :articles_updated_at, :timestamp
  end
end
