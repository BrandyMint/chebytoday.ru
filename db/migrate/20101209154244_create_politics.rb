class CreatePolitics < ActiveRecord::Migration
  def self.up
    create_table :politics do |t|
      t.string :name
      t.string :title
      t.text :desc
      t.timestamps
    end
  end

  def self.down
    drop_table :politics
  end
end
