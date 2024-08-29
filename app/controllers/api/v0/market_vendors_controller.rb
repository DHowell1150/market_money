class Api::V0::MarketVendorsController < ApplicationController 

  def create
    market = Market.find(params[:market_vendor_params][:market_id])
    vendor = Vendor.find(params[:market_vendor_params][:vendor_id])
    creation = MarketVendor.new(market: market, vendor: vendor)
    begin creation.save
      render json: MarketVendorSerializer.new(creation)
  end
end