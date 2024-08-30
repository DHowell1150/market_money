class Api::V0::MarketVendorsController < ApplicationController 
  def create
    market = Market.find(params[:market_id])
    vendor = Vendor.find(params[:vendor_id])
    if MarketVendor.find_by(market: market, vendor: vendor)
      render json: ErrorSerializer.new(ErrorMessage.new(0, 0)).market_vendor_exists(market.id, vendor.id), status: 422
    else
      market_vendor = MarketVendor.new(market: market, vendor: vendor)
      market_vendor.save!
      render json: MarketVendorSerializer.new.message, status: 201
    end
  end

  def destroy
    begin 
      market = Market.find(params[:market_id])
      vendor = Vendor.find(params[:vendor_id])
      market_vendor = MarketVendor.find_by(market: market, vendor: vendor)
      market_vendor.destroy
      render json: MarketVendorSerializer.new, status: 204
    
    rescue
      render json: ErrorSerializer.new(ErrorMessage.new("blank", "blank")).no_market_vendor(market.id, vendor.id), status: 404
    end
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404)).market_not_found, status: 404
  end
end
