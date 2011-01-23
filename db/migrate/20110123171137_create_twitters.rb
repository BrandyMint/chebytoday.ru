class CreateTwitters < ActiveRecord::Migration
  def self.up
    create_table :twitters, :id => false do |t|
      t.column :id, 'bigint', :options => 'primary key'
      t.string :screen_name, :null => false
      t.string :name
      t.string :profile_image_url
      t.integer :friends_count, :null => false, :default => 0
      t.integer :statuses_count, :null => false, :default => 0
      t.integer :favourites_count, :null => false, :default => 0
      t.integer :listed_count, :null => false, :default => 0
      t.string :location
      t.string :source, :null => false
      t.string :state, :null => false
      t.string :list_state, :null => false
      t.timestamp :twitter_created_at, :null => false
      t.timestamp :anounced_at

      t.timestamps
    end

    %w[state twitter_created_at friends_count statuses_count favourites_count listed_count].each do |c|
      add_index :twitters, c
    end
    add_index :twitters, :screen_name, :unique=>true

  end

  def self.down
    drop_table :twitters
  end
end
