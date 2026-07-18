class CreateListings < ActiveRecord::Migration[8.1]
  def change
    create_table :listings do |t|
      t.string :title
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :status, null: false, default: "active"
      t.references :seller, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
