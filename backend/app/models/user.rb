class User < ApplicationRecord
  has_many :listings, foreign_key: :seller_id, inverse_of: :seller, dependent: :destroy
  has_many :orders, foreign_key: :buyer_id, inverse_of: :buyer, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :fake_currency_balance, numericality: { greater_than_or_equal_to: 0 }
end
