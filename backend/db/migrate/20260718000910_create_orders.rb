class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :buyer, null: false, foreign_key: { to_table: :users }
      t.references :listing, null: false, foreign_key: true
      t.decimal :price_paid, precision: 10, scale: 2, null: false
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end
