class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.boolean :is_mained, :null=>false, :default=>false
      t.timestamp :published_at, :null=>false
      t.string :title, :null=>false
      t.string :author, :null=>false
      t.string :guid, :null=>false
      t.references :blog_source, :null=>false
      t.string :link
      t.text :summary, :null=>false
      t.text :description
      t.timestamps
    end

    add_index :articles, :guid, :unique=>true
    add_index :articles, :published_at
    add_index :articles, :is_mained
  end

  def self.down
    drop_table :articles
  end
end
