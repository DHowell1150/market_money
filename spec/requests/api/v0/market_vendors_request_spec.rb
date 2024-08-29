require 'rails_helper'

describe "market_vendors request" do
  describe "create" do
    it "can add a vendor to a market" do
      vendor1 = create(:vendor)
      vendor2 = create(:vendor)
      vendor3 = create(:vendor)
      market1 = create(:market)
      MarketVendor.create!(market: market1, vendor: vendor1)
      MarketVendor.create!(market: market1, vendor: vendor2)
      market_vendor_params = ({
                          market_id: market1.id,
                          vendor_id: vendor3.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}
      expect(market1.vendors.count).to eq(2)

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params: market_vendor_params)
      expect(response).to be_successful
      require 'pry'; binding.pry
      message = JSON.parse(response.body, symbolize_names: true)

      # additional assertions... not sure if they are needed
      created_market_vendor = MarketVendor.last 
      added_vendor = market1.vendors.last
      expect(created_market_vendor.market_id).to eq(market1.id)
      expect(created_market_vendor.vendor_id).to eq(vendor3.id)
      expect(market1.vendors.count).to eq(3)
      expect(added_vendor.id).to eq(vendor3.id)
    end
  end

  describe "sad path 1" do 
    it "can" do 
      
    end
  end
end
