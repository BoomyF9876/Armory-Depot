class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :display_name, null: false
      t.decimal :fake_currency_balance, precision: 10, scale: 2, null: false, default: 1000

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
