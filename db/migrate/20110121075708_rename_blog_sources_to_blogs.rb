class RenameBlogSourcesToBlogs < ActiveRecord::Migration
  def self.up
    rename_table :blog_sources, :blogs
  end

  def self.down
    rename_table :blogs, :blog_sources
  end
end
