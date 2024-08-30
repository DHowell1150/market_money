class Api::V0::MarketVendorsController < ApplicationController 
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  def create
    market = Market.find(params[:market_vendor_params][:market_id])
    vendor = Vendor.find(params[:market_vendor_params][:vendor_id])
    if MarketVendor.find_by(market: market, vendor: vendor)
      render json: ErrorSerializer.new(ErrorMessage.new(0, 0)).market_vendor_exists(market.id, vendor.id), status: 422
    else
      market_vendor = MarketVendor.new(market: market, vendor: vendor)
      market_vendor.save!
      render json: MarketVendorSerializer.new.message, status: 201
      
    # rescue ActiveRecord::RecordNotFound => exception
    #   render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 0)).market_not_found, status: 404
    end
  end

  def destroy
    begin 
      market = Market.find(params[:market_vendor_params][:market_id])
      vendor = Vendor.find(params[:market_vendor_params][:vendor_id])
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
