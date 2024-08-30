class Api::V0::MarketVendorsController < ApplicationController 

  def create
    begin
      market = Market.find(params[:market_vendor_params][:market_id])
      vendor = Vendor.find(params[:market_vendor_params][:vendor_id])
      MarketVendor.create(market: market, vendor: vendor)
      render json: MarketVendorSerializer.new.message, status: 201
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, "blank")).market_not_found, status: 404
    end
  end
end





