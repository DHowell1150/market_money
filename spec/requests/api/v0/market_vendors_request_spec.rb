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
      created_market_vendor = MarketVendor.last 

      expect(created_market_vendor.market_id).to eq(market1.id)
      expect(created_market_vendor.vendor_id).to eq(vendor3.id)

    end
  end
end
