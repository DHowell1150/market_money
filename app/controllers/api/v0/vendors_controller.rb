class Api::V0::VendorsController < ApplicationController
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
      render json: VendorSerializer.new(vendor), status: 201
    rescue ActiveRecord::RecordInvalid => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, "400"))
      .serialize_json, status: 400
    end
  end

def update
  vendor = Vendor.find(params[:id])
  vendor.update(vendor_params)
  render json: VendorSerializer.new(vendor)
end

def destroy
  vendor = Vendor.find(params[:id])
  vendor.destroy
end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end
