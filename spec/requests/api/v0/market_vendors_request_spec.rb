require 'rails_helper'

describe "market_vendors request" do
  describe "create - happy path" do
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
      expect(response.status).to eq(201)
      
      message = JSON.parse(response.body, symbolize_names: true)[:message]
      
      expect(message).to eq("Successfully added vendor to market")
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
    it "can return error when invalid market id is passed" do 
      vendor3 = create(:vendor)
      market_vendor_params = ({
                          market_id: "123123123123",
                          vendor_id: vendor3.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params: market_vendor_params)
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      
      message = JSON.parse(response.body, symbolize_names: true)[:errors].first[:detail]
      
      expect(message).to eq("Validation failed: Market must exist")
    end
  end

  describe "sad path 2" do 
    it "can return error when invalid market id is passed" do 
      vendor1 = create(:vendor)
      market1 = create(:market)
      MarketVendor.create!(market: market1, vendor: vendor1)
      
      
      market_vendor_params = ({
                          market_id: market1.id,
                          vendor_id: vendor1.id,
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params: market_vendor_params)
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      
      message = JSON.parse(response.body, symbolize_names: true)[:errors].first[:detail]
      
      expect(message).to eq("Validation failed: Market vendor asociation between market with market_id=#{market1.id} and vendor_id=#{vendor1.id} already exists")
    end
  end

  describe "delete - happy path" do
    it "can delete a market vendor relationship" do
      vendor1 = create(:vendor)
      vendor2 = create(:vendor)
      market1 = create(:market)
      MarketVendor.create!(market: market1, vendor: vendor1)
      MarketVendor.create!(market: market1, vendor: vendor2)
      market_vendor_params = ({
                          market_id: market1.id,
                          vendor_id: vendor2.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}
      expect(market1.vendors.count).to eq(2)

      delete api_v0_market_vendor_path(market1), headers: headers, params: JSON.generate(market_vendor_params: market_vendor_params)
      expect(response).to be_successful
      expect(response.status).to eq(204)
      
      expect(market1.vendors.count).to eq(1)
    end
  end
  
  describe "delete - sad path" do
    it "can return error when market vendor relationship does not exist" do
      vendor1 = create(:vendor)
      market1 = create(:market)
      market_vendor_params = ({
                          market_id: market1.id,
                          vendor_id: vendor1.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      delete api_v0_market_vendor_path(market1), headers: headers, params: JSON.generate(market_vendor_params: market_vendor_params)
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      
      message = JSON.parse(response.body, symbolize_names: true)[:errors].first[:detail]
      
      expect(message).to eq("No MarketVendor with market_id=#{market1.id} AND vendor_id=#{vendor1.id} exists")
    end
  end
end
