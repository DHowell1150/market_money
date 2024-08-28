class Api::V0::VendorsController < ApplicationController
  def show
    render json: VendorSerializer.new(Vendor.all)
  end
end