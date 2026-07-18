class Listing < ApplicationRecord
  belongs_to :seller, class_name: "User", inverse_of: :listings
  has_many :orders, dependent: :destroy

  validates :title, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[active sold removed] }
end
