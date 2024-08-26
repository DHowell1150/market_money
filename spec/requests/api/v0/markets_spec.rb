require 'rails_helper'

describe "markets API" do
  describe "index" do
    it "sends a list of markets" do
      market1 = create(:market)
      market2 = create(:market)
      market3 = create(:market)

      vendor1 = create(:vendor)
      vendor2 = create(:vendor)
      vendor3 = create(:vendor)
      vendor4 = create(:vendor)
      vendor5 = create(:vendor)
      
      MarketVendor.create!(market: market1.id, vendor: vendor1.id)
      MarketVendor.create!(market: market1.id, vendor: vendor2.id)
      MarketVendor.create!(market: market2.id, vendor: vendor3.id)
      MarketVendor.create!(market: market2.id, vendor: vendor4.id)
      MarketVendor.create!(market: market3.id, vendor: vendor5.id)

      get '/api/v0/markets'

      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)

      # expect(markets.count).to eq(3)

      # markets.each do |market|
      #   expect(market).to have_key(:id)
      #   expect(market[:id]).to be_an(Integer)

      #   expect(market).to have_key(:title)
      #   expect(market[:title]).to be_a(String)

      #   expect(market).to have_key(:author)
      #   expect(market[:author]).to be_a(String)

      #   expect(market).to have_key(:genre)
      #   expect(market[:genre]).to be_a(String)

      #   expect(market).to have_key(:summary)
      #   expect(market[:summary]).to be_a(String)

      #   expect(market).to have_key(:number_sold)
      #   expect(market[:number_sold]).to be_an(Integer)
      # end
    end
  end
end


# This endpoint should follow the pattern of GET /api/v0/markets and should return ALL markets in the database.
# In addition to the market’s main attributes, the market resource should also list an attribute for vendor_count, which is the number of vendors that are associated with that market.
