class Api::V1::ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :update, :destroy, :image]

  def index
    listings = Listing.where(status: "active").includes(:seller)
    render json: listings.map { |listing| listing_json(listing) }
  end

  def show
    render json: listing_json(@listing)
  end

  def create
    listing = Listing.new(listing_params)
    if listing.save
      render json: listing_json(listing), status: :created
    else
      render json: { errors: listing.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @listing.update(listing_params)
      render json: listing_json(@listing)
    else
      render json: { errors: @listing.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @listing.update(status: "removed")
    head :no_content
  end

  def image
    if @listing.image_data.present?
      send_data @listing.image_data, type: @listing.image_content_type, disposition: "inline"
    else
      head :not_found
    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :price, :status, :seller_id)
  end

  def listing_json(listing)
    listing
      .as_json(except: [:image_data], include: { seller: { only: [:id, :display_name] } })
      .merge("image_url" => listing.image_data.present? ? image_api_v1_listing_path(listing) : nil)
  end
end
