class CreateTwitUsers < ActiveRecord::Migration
  def self.up
    create_table :twit_users, :id=>false do |t|
      t.column :id, 'bigint', :options => 'primary key'
      t.string :screen_name
      t.string :profile_image_url
      t.integer :friends_count, :null=>false
      t.integer :statuses_count, :null=>false
      t.boolean :following
      t.boolean :is_cheboksary #, :null=>false, :default=>false
      t.string :state, :null=>false #, :default=>''
     # t.integer :twit_user_id
      t.timestamps
    end
    add_index :twit_users, :is_cheboksary
    add_index :twit_users, :state
    add_index :twit_users, :screen_name, :unique=>true
#    add_index :twit_users, :twit_user_id, :unique=>true
  end
  
  def self.down
    drop_table :twit_users
  end
end
