class CreateTwits < ActiveRecord::Migration
  def self.up
    create_table :twits, :id => false do |t|
      t.column :id, 'bigint', :options => 'primary key'
      t.text :text
      t.timestamp :created_at
      t.boolean :favorited
      t.string :place
      t.text :retweeted_status
      t.string :geo
      t.boolean :truncated
      t.string :source
      t.string :contributors
      t.string :coordinated
      t.column :twit_user_id, 'bigint'
      t.column :in_reply_to_user_id, 'bigint'
      t.column :in_reply_to_status_id, 'bigint'
      t.string :in_reply_to_screen_name

 #     t.string :search, :null=>false, :default=>''
      t.timestamps
    end

    add_index :twits, :id, :unique=>true
  end
  
  def self.down
    drop_table :twits
  end
end
