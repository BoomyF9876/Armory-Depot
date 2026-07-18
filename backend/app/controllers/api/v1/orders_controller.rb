class Api::V1::OrdersController < ApplicationController
  def create
    listing = Listing.find(params[:listing_id])
    buyer = User.find(order_params[:buyer_id])

    order = nil
    ActiveRecord::Base.transaction do
      raise ActiveRecord::RecordInvalid.new(listing) unless listing.status == "active"
      raise ActiveRecord::RecordInvalid.new(buyer) if buyer.fake_currency_balance < listing.price

      buyer.update!(fake_currency_balance: buyer.fake_currency_balance - listing.price)
      listing.seller.update!(fake_currency_balance: listing.seller.fake_currency_balance + listing.price)
      listing.update!(status: "sold")

      order = Order.create!(
        buyer: buyer,
        listing: listing,
        price_paid: listing.price,
        status: "completed"
      )
    end

    render json: order, status: :created
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  private

  def order_params
    params.require(:order).permit(:buyer_id)
  end
end
