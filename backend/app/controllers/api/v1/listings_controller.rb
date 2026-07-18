class Api::V1::ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :update, :destroy]

  def index
    listings = Listing.where(status: "active").includes(:seller)
    render json: listings.as_json(include: { seller: { only: [:id, :display_name] } })
  end

  def show
    render json: @listing
  end

  def create
    listing = Listing.new(listing_params)
    if listing.save
      render json: listing, status: :created
    else
      render json: { errors: listing.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @listing.update(listing_params)
      render json: @listing
    else
      render json: { errors: @listing.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @listing.update(status: "removed")
    head :no_content
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :price, :status, :seller_id)
  end
end
