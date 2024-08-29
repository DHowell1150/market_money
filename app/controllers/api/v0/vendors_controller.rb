class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index 
      market = Market.find(params[:market_id])
      render json: VendorSerializer.new(market.vendors)
  end

  def show
      render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    vendor = Vendor.new(vendor_params)

    begin vendor.save!
      render json: VendorSerializer.new(vendor)
    rescue ActiveRecord::RecordInvalid => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, "400"))
      .serialize_json, status: 400
    end
  end

def update
  vendor = Vendor.find(params[:id])
  begin vendor.update(vendor_params)
    render json: VendorSerializer.new(vendor)
  rescue 
    # render json: VendorSerializer.new(vendor)
  end
end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end
