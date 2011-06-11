class CreatePurchases < ActiveRecord::Migration
  def self.up
    create_table :purchases do |t|
      t.string :title
      t.string :image
      t.string :link
      t.date :end_date
      t.references :user
      t.text :description
      t.string :kind
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :purchases
  end
end
