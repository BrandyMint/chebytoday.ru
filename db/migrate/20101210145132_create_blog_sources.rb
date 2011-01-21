class CreateBlogSources < ActiveRecord::Migration
  def self.up
    create_table :blog_sources do |t|
      t.string :author
      t.string :name
      t.string :link
      t.timestamps
    end
  end

  def self.down
    drop_table :blog_sources
  end
end
