class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User", inverse_of: :orders
  belongs_to :listing

  validates :price_paid, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[pending completed cancelled] }
end
