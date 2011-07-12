class AddTypusAttributesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string
    add_column :users, :status, :boolean, :null=>false, :default=>true
    #User.find(1).update_attribute(:role,'admin')
  end

  def self.down
    remove_column :users, :role
    remove_column :users, :status
  end
end
