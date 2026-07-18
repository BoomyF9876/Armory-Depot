class AddImageToListings < ActiveRecord::Migration[8.1]
  def change
    add_column :listings, :image_data, :binary
    add_column :listings, :image_content_type, :string
  end
end
