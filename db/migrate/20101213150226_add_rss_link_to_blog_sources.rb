class AddRssLinkToBlogSources < ActiveRecord::Migration
  def self.up
    add_column :blog_sources, :rss_link, :string
  end

  def self.down
    remove_column :blog_sources, :rss_link
  end
end
