class AddPriceToPurchases < ActiveRecord::Migration
  def self.up
    add_column :purchases, :price, :integer
    add_column :purchases, :rebate, :integer
  end

  def self.down
    remove_column :purchases, :rebate
    remove_column :purchases, :price
  end
end
