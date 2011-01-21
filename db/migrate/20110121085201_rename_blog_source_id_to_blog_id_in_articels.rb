class RenameBlogSourceIdToBlogIdInArticels < ActiveRecord::Migration
  def self.up
    rename_column :articles, :blog_source_id, :blog_id
  end

  def self.down
    rename_column :articles, :blog_id, :blog_source_id
  end
end
