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

      markets = JSON.parse(response.body, symbolize_names: true)
require 'pry'; binding.pry
      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(Integer)

        expect(market).to have_key(:name)
        expect(market[:name]).to be_a(String)

        expect(market).to have_key(:street)
        expect(market[:street]).to be_a(String)

        expect(market).to have_key(:city)
        expect(market[:city]).to be_a(String)

        expect(market).to have_key(:county)
        expect(market[:county]).to be_a(String)

        expect(market).to have_key(:state)
        expect(market[:state]).to be_an(String)

        expect(market).to have_key(:zip)
        expect(market[:zip]).to be_an(String)

        expect(market).to have_key(:lat)
        expect(market[:lat]).to be_an(String)

        expect(market).to have_key(:lon)
        expect(market[:lon]).to be_an(String)

        expect(market).to have_key(:vendor_count)
        expect(market[:vendor_count]).to be_an(Integer)
      end
    end
  end
end


# This endpoint should follow the pattern of GET /api/v0/markets and should return ALL markets in the database.
# In addition to the market’s main attributes, the market resource should also list an attribute for vendor_count, which is the number of vendors that are associated with that market.
