class Api::V0::VendorsController < ApplicationController

  def index 
    begin
      market = Market.find(params[:market_id])
      render json: VendorSerializer.new(market.vendors)
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
    end
  end

  def show
    begin
      render json: VendorSerializer.new(Vendor.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
    end
  end
end

# render json: {
#   errors: [
#     {
#       status: "404",
#       title: exception.message
#     }
#   ]
# }, status: :not_found