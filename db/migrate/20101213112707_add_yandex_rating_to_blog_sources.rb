class AddYandexRatingToBlogSources < ActiveRecord::Migration
  def self.up
    add_column :blog_sources, :yandex_rating, :bigint
    add_column :blog_sources, :friends, :integer

    add_index :blog_sources, :yandex_rating
    add_index :blog_sources, :friends
    
  end

  def self.down
    remove_column :blog_sources, :friends
    remove_column :blog_sources, :yandex_rating
  end
end
