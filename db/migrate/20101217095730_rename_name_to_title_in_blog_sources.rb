class RenameNameToTitleInBlogSources < ActiveRecord::Migration
  def self.up
    rename_column :blog_sources, :name, :title
  end

  def self.down
    rename_column :blog_sources, :title, :name
  end
end
