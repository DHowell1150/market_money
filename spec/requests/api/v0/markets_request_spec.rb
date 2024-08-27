require 'rails_helper'

describe "markets API" do
  describe "index" do
    it "sends a list of markets" do
      vendor1 = create(:vendor)
      vendor2 = create(:vendor)
      vendor3 = create(:vendor)
      vendor4 = create(:vendor)
      vendor5 = create(:vendor)
      
      market1 = create(:market)
      market2 = create(:market)
      market3 = create(:market)

      MarketVendor.create!(market: market1, vendor: vendor1)
      MarketVendor.create!(market: market1, vendor: vendor2)
      MarketVendor.create!(market: market2, vendor: vendor3)
      MarketVendor.create!(market: market2, vendor: vendor4)
      MarketVendor.create!(market: market3, vendor: vendor5)

      get '/api/v0/markets'

      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)[:data]
      
      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be(String)
  
        expect(market).to have_key(:type)
        expect(market[:type]).to be(String)
  
        expect(market).to have_key(:attributes)
        expect(market[:attributes]).to be(Hash)
      end

      first_market = markets.first 

      expect(first_market[:attributes][:name]).to eq(market1.name)
      expect(first_market[:attributes][:street]).to eq(market1.street)
      expect(first_market[:attributes][:city]).to eq(market1.city)
      expect(first_market[:attributes][:county]).to eq(market1.county)
      expect(first_market[:attributes][:state]).to eq(market1.state)
      expect(first_market[:attributes][:zip]).to eq(market1.zip)
      expect(first_market[:attributes][:lat]).to eq(market1.lat)
      expect(first_market[:attributes][:lon]).to eq(market1.lon)
      expect(first_market[:attributes][:vendor_count]).to eq(market1.vendor_count)
    end
  end

  describe "show" do 
    xit "can send one market" do 
      # ...
    end
  end
  
end


# This endpoint should follow the pattern of GET /api/v0/markets and should return ALL markets in the database.
# In addition to the market’s main attributes, the market resource should also list an attribute for vendor_count, which is the number of vendors that are associated with that market.
