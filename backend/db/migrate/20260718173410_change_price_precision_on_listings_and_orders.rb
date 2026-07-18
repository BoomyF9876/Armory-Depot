class ChangePricePrecisionOnListingsAndOrders < ActiveRecord::Migration[8.1]
  def change
    change_column :listings, :price, :decimal, precision: 16, scale: 2
    change_column :orders, :price_paid, :decimal, precision: 16, scale: 2
  end
end
