class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index 
      market = Market.find(params[:market_id])
      render json: VendorSerializer.new(market.vendors)
  end

  def show
      render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def update
    vendor = Vendor.update(vendor_params)
    render json: VendorSerializer.new(Vendor.find(params[:vendor][:name]))
  end

  def create
    begin
      vendor = Vendor.new(vendor_params)
      if vendor.save
        render json: VendorSerializer.new(vendor)
      else #rescue ActiveRecord::RecordNotFound => exception
        render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
        .serialize_json, status_code: :bad_request
      end
    end
  end

  #   vendor = Vendor.new(vendor_params)
  #   require 'pry' ; binding.pry
  #   begin
  #     render json: VendorSerializer.new(vendor)
  #   rescue ActiveRecord::RecordNotFound => exception
  #     require 'pry' ; binding.pry
  #     render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
  #     .serialize_json, status: :bad_request
  #   end
  # end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end
